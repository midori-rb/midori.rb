require 'stringio'

module Midori::Server
  attr_accessor :request, :api, :on_open, :on_message, :on_close, :on_error

  def initialize(api)
    @api = api
    @request = Midori::Request.new
  end

  def post_init
    
  end

  def receive_data(data)
    port, ip = Socket.unpack_sockaddr_in(get_peername)
    @request.ip = ip
    @request.port = port
    if @request.parsed?
      #TODO: Implement method calling
    else
     receive_new_request(data)
    end
  end

  def receive_new_request(data)
    start_time = Time.now
    data = StringIO.new(data)
    begin
      @request.parse(data)
      @response = @api.receive(request, self)
    rescue Midori::Error::NotFound => _e
      @response = Midori::Response.new(404, {}, '404 Not Found')
    rescue => e
      @response = Midori::Response.new(500, {}, 'Internal Server Error')
      puts e.inspect
    end
    $stdout << "#{@request.ip} - - [#{Time.now.inspect}] \"#{@request.method} #{@request.path} #{@request.protocol}\" #{@response.status} #{Time.now.to_f - start_time.to_f}\n"
    unless (@request.websocket? || @request.eventsource?)
      send_data @response
      close_connection_after_writing
    end
  end
end