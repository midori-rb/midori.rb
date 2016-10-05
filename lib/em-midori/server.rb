require 'stringio'

module Midori::Server
  attr_accessor :request, :api

  def initialize(api)
    @api = api
    @request = Midori::Request.new
  end

  def post_init
    
  end

  def receive_data(data)
    if @request.parsed?
      #TODO: Implement method calling
    else
      receive_new_request(data)
    end
  end

  def receive_new_request(data)
    start_time = Time.now
    port, ip = Socket.unpack_sockaddr_in(get_peername)
    data = StringIO.new(data)
    begin
      @request.parse(data)
      @request.ip = ip
      @request.port = port
      case @request.method
        when 'WEBSOCKET'
          #TODO: implement websocket
        when 'EVENTSURCE'
          #TODO implement eventsource
        else
          @response = @api.receive(request)
      end
    rescue Midori::Error::NotFound => _e
      @response = Midori::Response.new(404, {}, '404 Not Found')
    rescue => e
      @response = Midori::Response.new(500, {}, 'Internal Server Error')
      puts e.inspect
    end
    $stdout << "#{@request.ip} - - [#{Time.now.inspect}] \"#{@request.method} #{@request.path} #{@request.protocol}\" #{@response.status} #{Time.now.to_f - start_time.to_f}\n"
    send_data @response
    close_connection_after_writing unless (@request.websocket? || @request.eventsource?)
  end
end