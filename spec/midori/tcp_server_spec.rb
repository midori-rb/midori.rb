require './spec/spec_helper'

RSpec.describe TCPServer do
  describe 'TCPServer' do
    it 'should use TCP Fast Open with correct options' do
      result = []
      backup = RUBY_PLATFORM
      RUBY_PLATFORM = 'x86_64-darwin17'
      socket = TCPServer.new('127.0.0.1', 8081)
      result << socket.tcp_fast_open
      socket.close
      RUBY_PLATFORM = 'x86_64-linux'
      socket = TCPServer.new('127.0.0.1', 8081)
      result << socket.tcp_fast_open
      # Restore the setting
      RUBY_PLATFORM = backup
      expect(result.select{ |a| a }.count).to eq(1)
    end
  end
end
