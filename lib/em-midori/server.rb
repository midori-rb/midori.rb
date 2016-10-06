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
    $stdout << "#{@request.ip} - - [#{Time.now.inspect}] \"#{@request.method} #{@request.path} #{@request.protocol}\" #{@response.status} #{(Time.now.to_f - start_time.to_f).round(5)}\n".green
  end

  def receive_new_request(data)
    begin
      @request.parse(data)
      @response = @api.receive(request, self)
    rescue Midori::Error::NotFound => _e
      @response = Midori::Response.new(404, {}, '404 Not Found')
    rescue => e
      @response = Midori::Response.new(500, {}, 'Internal Server Error')
      puts e.inspect.yellow
    end
    unless (@request.websocket? || @request.eventsource?)
      send_data @response
      close_connection_after_writing
    end
    if @request.websocket? && !@websocket.events[:open].nil?
      lambda {@websocket.instance_exec(&@websocket.events[:open])}.call
    end
  end

  def websocket_request(data)
    begin
      @websocket.decode(data)
      case @websocket.opcode
        when 0x1, 0x2
          call_event(:message, @websocket.msg)
        when 0x9
          call_event(:ping)
          @websocket.pong
        when 0xA
          call_event(:pong)
        else
          # Unknown Control Frame
          raise Midori::Error::FrameEnd
      end
    rescue Midori::Error::FrameEnd => _e
      unless @websocket.events[:close].nil?
        call_event(:close)
      end
      send_data "\b" # Opcode 0x8
      close_connection_after_writing
    rescue => e
      puts e.inspect.yellow
      @response = Midori::Response.new(400, {}, 'Bad Request')
      send_data @response
      close_connection_after_writing
    end
  end
  
  def call_event(event, args=[])
    lambda {@websocket.instance_exec(*args, &@websocket.events[event])}.call unless @websocket.events[event].nil?
  end

end