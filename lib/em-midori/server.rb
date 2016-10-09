require 'stringio'

module Midori::Server
  attr_accessor :request, :api, :websocket

  def initialize(api)
    @api = api
    @request = Midori::Request.new
    @websocket = Midori::WebSocket.new(self)
  end

  def receive_data(data)
    start_time = Time.now
    data = StringIO.new(data)
    port, ip = Socket.unpack_sockaddr_in(get_peername)
    @request.ip = ip
    @request.port = port
    if @request.parsed?
      websocket_request(data)
    else
      receive_new_request(data)
    end
    puts "#{@request.ip} - - [#{Time.now.inspect}] \"#{@request.method} #{@request.path} #{@request.protocol}\" #{@response.status} #{(Time.now.to_f - start_time.to_f).round(5)}".green
  end

  def receive_new_request(data)
    begin
      @request.parse(data)
      @response = @api.receive(request, self)
      call_event(:open) if @request.websocket?
    rescue Midori::Error::NotFound => _e
      @response = Midori::Response.new(404, {}, '404 Not Found')
    rescue => e
      @response = Midori::Response.new(500, {}, 'Internal Server Error')
      puts e.inspect.red
      puts e.backtrace.join("\n").yellow
    end
    unless @request.websocket? || @request.eventsource?
      send_data @response
      close_connection_after_writing
    end
  end

  def websocket_request(data)
    @websocket.decode(data)
    case @websocket.opcode
    when 0x1, 0x2
      call_event(:message, @websocket.msg)
    when 0x9
      @websocket.pong(@websocket.msg)
      call_event(:ping)
    when 0xA
      call_event(:pong)
    else
      raise Midori::Error::FrameEnd
    end
  rescue Midori::Error::FrameEnd => _e
    call_event(:close)
    send_data "\b" # Opcode 0x8
    close_connection_after_writing
  rescue Midori::Error::PingPingSizeTooLarge => _e
    call_event(:error)
    close_connection
  rescue => e
    call_event(:error)
    puts e.inspect.red
    puts e.backtrace.join("\n").yellow
    close_connection_after_writing
  end

  def call_event(event, args = [])
    -> { @websocket.instance_exec(*args, &@websocket.events[event]) }.call unless @websocket.events[event].nil?
  end
end
