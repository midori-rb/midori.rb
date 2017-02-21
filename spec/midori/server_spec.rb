require './spec/spec_helper'
require 'net/http'
require 'socket'

RSpec.describe Midori::Server do
  runner = EXAMPLE_RUNNER

  before(:all) do
    Thread.new { runner.start }
    sleep 1
  end

  describe 'Basic Requests' do
    it 'should return \'Hello World\' on GET / request' do
      Timeout::timeout(1) do
        expect(Net::HTTP.get(URI('http://127.0.0.1:8080/'))).to eq('Hello World')
      end
    end

    it 'could deal with very large response' do
      Timeout::timeout(5) do
        expect(Net::HTTP.get(URI('http://127.0.0.1:8080/large'))).to eq('w' * 2 * 20)
      end
    end

    it 'should return \'Hello World\' on GET /2 request' do
      Timeout::timeout(1) do
        expect(Net::HTTP.get(URI('http://127.0.0.1:8080/2'))).to eq('Hello World')
      end
    end

    it 'should return 404 Not Found on GET /not_found_error' do
      Timeout::timeout(1) do
        expect(Net::HTTP.get(URI('http://127.0.0.1:8080/not_found_error'))).to eq('404 Not Found')
      end
    end

    it 'should return 500 Internal Server Error on GET /error' do
      Timeout::timeout(1) do
        expect(Net::HTTP.get_response(URI('http://127.0.0.1:8080/error')).code).to eq('500')
      end
    end

    it 'should pass test error definition' do
      Timeout::timeout(1) do
        expect(Net::HTTP.get(URI('http://127.0.0.1:8080/test_error'))).to eq('Hello Error')
      end
    end
  end

  describe 'WebSocket' do
    it 'pass example websocket communication' do
      Timeout::timeout(1) do
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
    end

    it 'raise error when sending unsupported OpCode' do
      Timeout::timeout(1) do
        socket = TCPSocket.new '127.0.0.1', 8080
        socket.print "GET /websocket/opcode HTTP/1.1\r\nHost: localhost:8080\r\nConnection: Upgrade\r\nUpgrade: websocket\r\nSec-WebSocket-Version: 13\r\nSec-WebSocket-Key: sGxYzKDBdoC2s8ZImlNgow==\r\n\r\n"
        # Upgrade
        result = Array.new(5) {socket.gets}
        expect(result[0]).to eq("HTTP/1.1 101 Switching Protocols\r\n")
        expect(result[3]).to eq("Sec-WebSocket-Accept: zRZMou/76VWlXHo5eoxTMg3tQKQ=\r\n")
        # Connection lost
        socket.close
      end
    end

    it 'pings' do
      Timeout::timeout(1) do
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
    end

    it 'send too large ping' do
      Timeout::timeout(1) do
        socket = TCPSocket.new '127.0.0.1', 8080
        socket.print "GET /websocket/too_large_ping HTTP/1.1\r\nHost: localhost:8080\r\nConnection: Upgrade\r\nUpgrade: websocket\r\nSec-WebSocket-Version: 13\r\nSec-WebSocket-Key: sGxYzKDBdoC2s8ZImlNgow==\r\n\r\n"
        # Upgrade
        result = Array.new(5) {socket.gets}
        expect(result[0]).to eq("HTTP/1.1 101 Switching Protocols\r\n")
        expect(result[3]).to eq("Sec-WebSocket-Accept: zRZMou/76VWlXHo5eoxTMg3tQKQ=\r\n")
        socket.print [0x81, 0x85, 0x37, 0xfa, 0x21, 0x3d, 0x7f, 0x9f, 0x4d, 0x51, 0x58].pack('C*')
        result = socket.getbyte
        expect(result).to eq(0x8)
        socket.close
      end
    end

    it 'wrong opcode' do
      Timeout::timeout(1) do
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
  end

  describe 'EventSource' do
    it 'should pass Hello World test' do
      Timeout::timeout(1) do
        uri = URI('http://127.0.0.1:8080/eventsource')
        req = Net::HTTP::Get.new(uri)
        req['Accept'] = 'text/event-stream'
        res = Net::HTTP.start(uri.hostname, uri.port) do |http|
          http.request(req)
        end
        expect(res.body).to eq("data: Hello\ndata: World\n\n")
      end
    end
  end
end
