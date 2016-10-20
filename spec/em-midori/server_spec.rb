require './spec/spec_helper'
require 'net/http'
require 'socket'

include Midori
class Example < API
  helper do
    def test_helper
      puts 'Hello'
    end
  end

  get '/' do
    test_helper
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

    ws.on :pong do
      ws.send ''
      puts 'on Pong'.green
    end

    ws.on :close do
      puts 'on Close'.green
    end
  end

  websocket '/websocket/opcode' do |ws|
    ws.on :open do
      ws.send Object.new
    end
  end

  websocket '/websocket/ping' do |ws|
    ws.on :open do
      ws.ping ''
    end
  end

  websocket '/websocket/too_large_ping' do |ws|
    ws.on :message do
      ws.ping '01234567890123456789012345678901
      23456789012345678901234567890123456789012
      34567890123456789012345678901234567890123
      45678901234567890123456789012345678901234
      56789012345678901234567890123456789012345
      67890123456789012345678901234567890123456
      78901234567890123456789012345678901234567
      89012345678901234567890123456789012345678
      90123456789012345678901234567890123456789
      012345678901234567890123456789'
    end
  end

  websocket '/websocket/wrong_opcode' do |ws|;end

  eventsource '/eventsource' do |es|
    es.send("Hello\nWorld")
  end

end

RSpec.describe Midori do
  describe 'Server' do
    it 'should not stop before started' do
      expect(Midori.stop).to eq(false)
    end

    it 'should start properly' do
      expect do
        Thread.new { Midori.run(Example, '127.0.0.1', 8080, Logger.new(StringIO.new)) }
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
    it 'pass example websocket communication' do
      socket = TCPSocket.new '127.0.0.1', 8080
      socket.print "GET /websocket HTTP/1.1\r\nHost: localhost:8080\r\nConnection: Upgrade\r\nUpgrade: websocket\r\nSec-WebSocket-Version: 13\r\nSec-WebSocket-Key: sGxYzKDBdoC2s8ZImlNgow==\r\n\r\n"
      # Upgrade
      result = Array.new(5) {socket.gets}
      expect(result[0]).to eq("HTTP/1.1 101 Switching Protocols\r\n")
      expect(result[3]).to eq("Sec-WebSocket-Accept: zRZMou/76VWlXHo5eoxTMg3tQKQ=\r\n")
      # Receive 'Hello' on Open
      result = Array.new(7) {socket.getbyte}
      expect(result).to eq([0x81, 0x05, 0x48, 0x65, 0x6c, 0x6c, 0x6f])
      # Receive 'Hello' after sending 'Hello'
      socket.print [0x81, 0x85, 0x37, 0xfa, 0x21, 0x3d, 0x7f, 0x9f, 0x4d, 0x51, 0x58].pack('C*')
      result = Array.new(7) {socket.getbyte}
      expect(result).to eq([0x81, 0x05, 0x48, 0x65, 0x6c, 0x6c, 0x6f])
      # Receive 'Hello' pong after sending 'Hello' ping
      socket.print [0x89, 0x85, 0x37, 0xfa, 0x21, 0x3d, 0x7f, 0x9f, 0x4d, 0x51, 0x58].pack('C*')
      result = Array.new(7) {socket.getbyte}
      expect(result).to eq([0x8a, 0x05, 0x48, 0x65, 0x6c, 0x6c, 0x6f])
      # Receive [1, 2, 3] after sending [1, 2, 3]
      socket.print [0x82, 0x83, 0xac, 0xfe, 0x1a, 0x97, 0xad, 0xfc, 0x19].pack('C*')
      result = Array.new(5) {socket.getbyte}
      expect(result).to eq([0x82, 0x3, 0x1, 0x2, 0x3])
      # Try send pong 'Hello'
      socket.print [0x8a, 0x85, 0x37, 0xfa, 0x21, 0x3d, 0x7f, 0x9f, 0x4d, 0x51, 0x58].pack('C*')
      result = Array.new(2) {socket.getbyte}
      expect(result).to eq([0x81, 0x0])
      # Expect WebSocket close
      socket.print [0x48].pack('C*')
      result = socket.getbyte
      expect(result).to eq(0x8)
      socket.close
    end

    it 'raise error when sending unsupported OpCode' do
      socket = TCPSocket.new '127.0.0.1', 8080
      socket.print "GET /websocket/opcode HTTP/1.1\r\nHost: localhost:8080\r\nConnection: Upgrade\r\nUpgrade: websocket\r\nSec-WebSocket-Version: 13\r\nSec-WebSocket-Key: sGxYzKDBdoC2s8ZImlNgow==\r\n\r\n"
      # Upgrade
      result = Array.new(5) {socket.gets}
      expect(result[0]).to eq("HTTP/1.1 101 Switching Protocols\r\n")
      expect(result[3]).to eq("Sec-WebSocket-Accept: zRZMou/76VWlXHo5eoxTMg3tQKQ=\r\n")
      # Connection lost
      socket.close
    end

    it 'pings' do
      socket = TCPSocket.new '127.0.0.1', 8080
      socket.print "GET /websocket/ping HTTP/1.1\r\nHost: localhost:8080\r\nConnection: Upgrade\r\nUpgrade: websocket\r\nSec-WebSocket-Version: 13\r\nSec-WebSocket-Key: sGxYzKDBdoC2s8ZImlNgow==\r\n\r\n"
      # Upgrade
      result = Array.new(5) {socket.gets}
      expect(result[0]).to eq("HTTP/1.1 101 Switching Protocols\r\n")
      expect(result[3]).to eq("Sec-WebSocket-Accept: zRZMou/76VWlXHo5eoxTMg3tQKQ=\r\n")
      result = Array.new(2) {socket.getbyte}
      expect(result).to eq([0x89, 0x0])
      socket.close
    end

    it 'send too large ping' do
      socket = TCPSocket.new '127.0.0.1', 8080
      socket.print "GET /websocket/too_large_ping HTTP/1.1\r\nHost: localhost:8080\r\nConnection: Upgrade\r\nUpgrade: websocket\r\nSec-WebSocket-Version: 13\r\nSec-WebSocket-Key: sGxYzKDBdoC2s8ZImlNgow==\r\n\r\n"
      # Upgrade
      result = Array.new(5) {socket.gets}
      expect(result[0]).to eq("HTTP/1.1 101 Switching Protocols\r\n")
      expect(result[3]).to eq("Sec-WebSocket-Accept: zRZMou/76VWlXHo5eoxTMg3tQKQ=\r\n")
      socket.print [0x81, 0x85, 0x37, 0xfa, 0x21, 0x3d, 0x7f, 0x9f, 0x4d, 0x51, 0x58].pack('C*')
      socket.close
    end

    it 'wrong opcode' do
      socket = TCPSocket.new '127.0.0.1', 8080
      socket.print "GET /websocket/wrong_opcode HTTP/1.1\r\nHost: localhost:8080\r\nConnection: Upgrade\r\nUpgrade: websocket\r\nSec-WebSocket-Version: 13\r\nSec-WebSocket-Key: sGxYzKDBdoC2s8ZImlNgow==\r\n\r\n"
      # Upgrade
      result = Array.new(5) {socket.gets}
      expect(result[0]).to eq("HTTP/1.1 101 Switching Protocols\r\n")
      expect(result[3]).to eq("Sec-WebSocket-Accept: zRZMou/76VWlXHo5eoxTMg3tQKQ=\r\n")
      socket.print [0x83, 0x85, 0x37, 0xfa, 0x21, 0x3d, 0x7f, 0x9f, 0x4d, 0x51, 0x58].pack('C*')
      socket.close
    end
  end

  describe 'EventSource' do
    it 'should pass Hello World test' do
      uri = URI('http://127.0.0.1:8080/eventsource')
      req = Net::HTTP::Get.new(uri)
      req['Accept'] = 'text/event-stream'
      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
      expect(res.body).to eq("data: Hello\ndata: World\n\n")
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
