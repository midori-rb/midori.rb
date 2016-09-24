module Midori::Server
  def self.load_api(api)
    @api = api
    self
  end

  def receive_data(data)
    port, ip = Socket.unpack_sockaddr_in(get_peername)
    puts "from #{ip}:#{port} comes a message:"
    #puts data
    send_data "HTTP/1.1 200 OK\r\n\r\nHello World"
    close_connection_after_writing
  end
end