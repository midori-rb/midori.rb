require './spec/spec_helper'

RSpec.describe Socket do
  describe 'Socket' do
    it 'should use TCP Fast Open feature' do
      socket = Socket.new Socket::AF_INET, Socket::SOCK_STREAM
      socket.reuse_port if Midori::Configure.socket_reuse_port
      socket.bind Addrinfo.tcp '127.0.0.1', 8081
      socket.listen Socket::SOMAXCONN
      expect(socket.tcp_fast_open).to eq(true)
      socket.close
      # You cannot set it again when socket's closed
      expect(socket.tcp_fast_open).to eq(false)
    end
  end
end
