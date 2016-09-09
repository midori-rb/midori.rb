# encoding: utf-8
require 'eventmachine'

module EMMidori
  def self.run!
    EventMachine.run {
      EventMachine.start_server '0.0.0.0', 8081, EMMidori::Server
    }
  end

  at_exit {EMMidori.run!}
end

module EMMidori::Server
  def receive_data(data)
    port, ip = Socket.unpack_sockaddr_in(get_peername)
    puts "from #{ip}:#{port} comes a message:"
    puts data
    send_data 'Hello World'
    close_connection_after_writing
  end
end
