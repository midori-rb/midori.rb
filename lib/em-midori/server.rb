require 'stringio'

module Midori::Server
  class << self
    attr_accessor :api
  end

  def receive_data(data)
    start_time = Time.now
    port, ip = Socket.unpack_sockaddr_in(get_peername)
    data = StringIO.new(data)
    begin
      request = Midori::Request.new(data)
      request.ip = ip
      request.port = port
      response = Midori::Server.api.receive(request)
    rescue Midori::Error::NotFound => _e
      response = Midori::Response.new(404, {}, '404 Not Found')
    rescue => e
      response = Midori::Response.new(500, {}, 'Internal Server Error')
      puts e.inspect
    end
    $stdout << "#{request.ip} - - [#{Time.now.inspect}] \"#{request.method} #{request.path} #{request.protocol}\" #{response.status} #{Time.now.to_f - start_time.to_f}\n"
    send_data response
    close_connection_after_writing
  end
end