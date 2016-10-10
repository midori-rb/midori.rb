require 'em-midori'
require './spec/spec_helper'
require 'net/http'
require 'socket'

include Midori
class Example < API
  get '/' do
    next 'Hello World'
  end

  get '/error' do
    raise StandardError
  end

  get '/test_error' do
    define_error :test_error
    begin
      raise TestError
    rescue TestError => _e
      next 'Hello Error'
    end
  end

  websocket '/websocket' do |ws|
    ws.on :open do
      ws.send 'Hello'
      puts 'on Open '.green
    end

    ws.on :message do |msg|
      puts 'on Message'.green
      ws.send msg
    end

    ws.on :close do
      puts 'on Close'.green
    end
  end
end

RSpec.describe Midori do
  describe 'Server' do
    it 'should not stop before started' do
      expect(Midori.stop).to eq(false)
    end

    it 'should start properly' do
      expect do
        Thread.new { Midori.run(Example, '127.0.0.1', 8080) }
        sleep(1)
      end.to_not raise_error(RuntimeError)
    end
  end

  describe 'Basic Requests' do
    it 'should return \'Hello World\' on GET / request' do
      expect(Net::HTTP.get(URI('http://127.0.0.1:8080/'))).to eq('Hello World')
    end

    it 'should return 404 Not Found on GET /not_found_error' do
      expect(Net::HTTP.get(URI('http://127.0.0.1:8080/not_found_error'))).to eq('404 Not Found')
    end

    it 'should return 500 Internal Server Error on GET /error' do
      expect(Net::HTTP.get(URI('http://127.0.0.1:8080/error'))).to eq('Internal Server Error')
    end

    it 'should pass test error definition' do
      expect(Net::HTTP.get(URI('http://127.0.0.1:8080/test_error'))).to eq('Hello Error')
    end
  end

  describe 'WebSocket' do
    it 'pass websocket connection' do
      socket = TCPSocket.new '127.0.0.1', 8080
      socket.print "GET /websocket HTTP/1.1\r\nHost: localhost:8080\r\nConnection: Upgrade\r\nUpgrade: websocket\r\nSec-WebSocket-Version: 13\r\nSec-WebSocket-Key: sGxYzKDBdoC2s8ZImlNgow==\r\n\r\n"
      # Upgrade
      result = Array.new(5) {socket.gets}
      expect(result[0]).to eq("HTTP/1.1 101 Switching Protocols\r\n")
      expect(result[3]).to eq("Sec-WebSocket-Accept: zRZMou/76VWlXHo5eoxTMg3tQKQ=\r\n")
      # Received 'Hello' on Open
      result = Array.new(7) {socket.getbyte}
      expect(result).to eq([0x81, 0x05, 0x48, 0x65, 0x6c, 0x6c, 0x6f])
      # Received 'Hello' after sending 'Hello'
      socket.print [0x81, 0x85, 0x37, 0xfa, 0x21, 0x3d, 0x7f, 0x9f, 0x4d, 0x51, 0x58].pack('C*')
      result = Array.new(7) {socket.getbyte}
      expect(result).to eq([0x81, 0x05, 0x48, 0x65, 0x6c, 0x6c, 0x6f])
      # Received 'Hello' pong after sending 'Hello' ping
      socket.print [0x89, 0x85, 0x37, 0xfa, 0x21, 0x3d, 0x7f, 0x9f, 0x4d, 0x51, 0x58].pack('C*')
      result = Array.new(7) {socket.getbyte}
      expect(result).to eq([0x8a, 0x05, 0x48, 0x65, 0x6c, 0x6c, 0x6f])
      # Expect WebSocket close
      socket.print [0x48].pack('C*')
      result = socket.getbyte
      expect(result).to eq(0x8)
      socket.close
    end
  end

  describe 'Server' do
    it 'should stop properly' do
      expect(Midori.stop).to eq(true)
      sleep(1)
    end

    it 'should not receive anything after stopped' do
      expect do
        puts Net::HTTP.get(URI('http://127.0.0.1:8080/'))
        Net::HTTP.get(URI('http://127.0.0.1:8080/'))
      end.to raise_error(Errno::ECONNREFUSED)
    end

    it 'should not stop after stopped' do
      expect(Midori.stop).to eq(false)
    end
  end
end
