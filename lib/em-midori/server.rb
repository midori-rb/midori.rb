module Midori::Server
  class << self
    attr_accessor :api
  end

  def receive_data(data)
    port, ip = Socket.unpack_sockaddr_in(get_peername)
    response = Midori::Server.api.receive(data)
    puts "from #{ip}:#{port} comes a message:"
    puts data # Debug
    puts response # Debug
    send_data response
    close_connection_after_writing
  end
end