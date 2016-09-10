module Midori::Server
  def receive_data(data)
    port, ip = Socket.unpack_sockaddr_in(get_peername)
    puts "from #{ip}:#{port} comes a message:"
    #puts data
    send_data 'Hello World'
    close_connection_after_writing
  end
end
