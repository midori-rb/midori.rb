require 'em-midori'
require './spec/spec_helper'

puts File.dirname(__FILE__)

RSpec.describe Midori::Request do
  describe 'Request' do
    it 'parse request without query_string' do
      data = "GET / HTTP/1.1\r\n\r\n"
      data = StringIO.new(data)
      request = Midori::Request.new(data)
      expect do
        request.parse(1)
      end.to raise_error(RuntimeError)
      request.parse(0)
      expect(request.protocol).to eq('HTTP/1.1')
      expect(request.method).to eq('GET')
      expect(request.path).to eq('/')
      expect(request.query_string).to eq(nil)
      request.parse(1)
      expect do
        request.parse(2)
      end.to raise_error(RuntimeError)
    end

    it 'parse request with query_string' do
      data = "GET /?test=1 HTTP/1.1\r\n\r\n"
      data = StringIO.new(data)
      request = Midori::Request.new(data)
      request.parse(0)
      expect(request.protocol).to eq('HTTP/1.1')
      expect(request.method).to eq('GET')
      expect(request.path).to eq('/')
      expect(request.query_string).to eq('test=1')
    end
  end

  it 'parse request with header and body' do
    data = StringIO.new("GET / HTTP/1.1\r\nTest: Hello\r\n\r\nBody")
    request = Midori::Request.new(data)
    request.parse(0)
    request.parse(1)
    expect(request.header['Test']).to eq('Hello')
    expect(request.body).to eq('Body')
  end
end