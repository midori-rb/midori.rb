require './spec/spec_helper'
require 'json'

include Midori

class RawHello < API
  use Middleware
  get '/' do
    'Hello'
  end
  post '/' do; end
  put '/' do; end
  delete '/' do; end
  options '/' do; end
  link '/' do; end
  unlink '/' do; end
  websocket '/' do; end
  eventsource '/' do; end
end

class JSONMiddleware < Middleware
  def self.before(request)
    request.body = JSON.parse(request.body) unless request.body == ''
    request
  end

  def self.after(_request, response)
    response.header['Content-Type'] = 'application/json'
    response.body = response.body.to_json
    response
  end

  def self.accept
    [Hash, Array]
  end
end

class JSONHello < Midori::API
  use JSONMiddleware
  get '/' do
    {code: 0}
  end
end

RSpec.describe API do
  describe 'match' do
    it 'should match GET /test with GET string /test' do
      expect(API.match('GET', API.convert_route('/test'), 'GET', '/test')).to eq([])
    end
    it 'should not match GET /test with GET string /test/' do
      expect(API.match('GET', API.convert_route('/test'), 'GET', '/test/')).to eq(false)
    end
    it 'should match GET /test/hello with GET string /test/:id' do
      expect(API.match('GET', API.convert_route('/test/:id'), 'GET', '/test/hello')).to eq(['hello'])
    end
    it 'should match GET /test/foo/order/bar with GET string /test/:id/order/:order_id' do
      expect(API.match('GET', API.convert_route('/test/:id/order/:order_id'), 'GET', '/test/foo/order/bar')).to eq(%w'foo bar')
    end
    it 'should match GET /test/hello with GET regex /\/test\/(.*?)/' do
      expect(API.match('GET', /^\/test\/(.*?)$/, 'GET', '/test/hello')).to eq(['hello'])
    end
    it 'should not match GET /test_no/hello with GET regex /\/test\/(.*?)/' do
      expect(API.match('GET', /^\/test\/(.*?)$/, 'GET', '/test_no/hello')).to eq(false)
    end
    it 'should not match POST /test with GET string /test' do
      expect(API.match('GET', API.convert_route('/test'), 'POST', '/test')).to eq(false)
    end
  end

  describe 'JSONHello' do
    it 'should response {code: 0} as json string with middleware' do
      request = Midori::Request.new
      request.parsed = true
      request.method = 'GET'
      request.path = '/'
      request.header = {}
      request.body = ''
      expect(JSONHello.receive(request, nil).body).to eq({code: 0}.to_json)
    end
  end

  describe 'RawHello' do
    it 'should response {code: 0} as json string with middleware' do
      request = Midori::Request.new
      request.parsed = true
      request.method = 'GET'
      request.path = '/'
      request.header = {}
      request.body = ''
      expect(RawHello.receive(request, nil).body).to eq('Hello')
    end
  end
end
