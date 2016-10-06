require 'stringio'

module Midori::Server
  attr_accessor :request, :api, :on_open, :on_message, :on_close

  def initialize(api)
    @api = api
    @request = Midori::Request.new
    @websocket = Midori::WebSocket.new
  end

  def receive_data(data)
    start_time = Time.now
    data = StringIO.new(data)
    port, ip = Socket.unpack_sockaddr_in(get_peername)
    @request.ip = ip
    @request.port = port
    if @request.parsed?
      @websocket.decode_mask(data)
      puts @websocket.msg
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
  end

  def connection_completed

  end
end