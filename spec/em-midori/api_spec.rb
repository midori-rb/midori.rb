require './spec/spec_helper'

include Midori

class Hello < API
  get '/' do; end
  post '/' do; end
  put '/' do; end
  delete '/' do; end
  options '/' do; end
  link '/' do; end
  unlink '/' do; end
  websocket '/' do; end
  eventsource '/' do; end
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
end
