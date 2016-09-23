require 'em-midori'

class Hello < Midori::API
  get '/' do
    puts 'Hello World'
  end
  post '/' do
    puts 'Hello World'
  end
  put '/' do
    puts 'Hello World'
  end
  delete '/' do
    puts 'Hello World'
  end
  options '/' do
    puts 'Hello World'
  end
  link '/' do
    puts 'Hello World'
  end
  unlink '/' do
    puts 'Hello World'
  end
  websocket '/' do
    puts 'Hello World'
  end
  eventsource '/' do
    puts 'Hello World'
  end
end

Hello.new

RSpec.describe Midori::API do
  describe 'match' do
    it 'should match GET /test with GET string /test' do
      expect(Midori::API.match('GET', '/test', 'GET /test')).to eq([])
    end
    it 'should not match GET /test with GET string /test/' do
      expect(Midori::API.match('GET', '/test', 'GET /test/')).to eq(false)
    end
    it 'should match GET /test/hello with GET string /test/:id' do
      expect(Midori::API.match('GET', '/test/:id', 'GET /test/hello')).to eq(['hello'])
    end
    it 'should match GET /test/foo/order/bar with GET string /test/:id/order/:order_id' do
      expect(Midori::API.match('GET', '/test/:id/order/:order_id', 'GET /test/foo/order/bar')).to eq(%w'foo bar')
    end
    it 'should match GET /test/hello with GET regex /\/test\/(.*?)/' do
      expect(Midori::API.match('GET', /^\/test\/(.*?)$/, 'GET /test/hello')).to eq(['hello'])
    end
    it 'should not match GET /test_no/hello with GET regex /\/test\/(.*?)/' do
      expect(Midori::API.match('GET', /^\/test\/(.*?)$/, 'GET /test_no/hello')).to eq(false)
    end
    it 'should not match POST /test with GET string /test' do
      expect(Midori::API.match('GET', '/test', 'POST /test')).to eq(false)
    end
  end
end
