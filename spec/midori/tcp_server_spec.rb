require './spec/spec_helper'

RSpec.describe TCPServer do
  describe 'TCPServer' do
    it 'should use TCP Fast Open feature' do
      socket = TCPServer.new('127.0.0.1', 8081)
      expect(socket.tcp_fast_open).to eq(true)
      socket.close
      # You cannot set it again when socket's closed
      expect(socket.tcp_fast_open).to eq(false)
    end
  end
end
