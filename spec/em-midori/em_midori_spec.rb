require 'em-midori'
require './spec/spec_helper'
require 'net/http'

include Midori
class Example < API
  get '/' do
    'Hello World'
  end

  get '/error' do
    raise StandardError
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

    it 'should return \'Hello World\' on GET / request' do
      expect(Net::HTTP.get(URI('http://127.0.0.1:8080/'))).to eq('Hello World')
    end

    it 'should return 404 Not Found on GET /not_found_error' do
      expect(Net::HTTP.get(URI('http://127.0.0.1:8080/not_found_error'))).to eq('404 Not Found')
    end

    it 'should return 500 Internal Server Error on GET /error' do
      expect(Net::HTTP.get(URI('http://127.0.0.1:8080/error'))).to eq('Internal Server Error')
    end

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