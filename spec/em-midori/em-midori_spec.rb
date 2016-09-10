require 'em-midori'
require './spec/spec_helper'
require 'net/http'


RSpec.describe Midori do
  describe 'Server' do
    it 'should not stop before started' do
      expect(Midori.stop).to eq(false)
    end

    it 'should start properly' do
      expect do
        Thread.new { Midori.run(Midori::API, '127.0.0.1', 8080) }
        sleep(1)
      end.to_not raise_error(RuntimeError)
    end

    it 'should return \'Hello World\' on any request' do
      expect(Net::HTTP.get(URI('http://127.0.0.1:8080/'))).to eq('Hello World')
    end

    it 'should stop properly' do
      expect(Midori.stop).to eq(true)
      sleep(1)
    end

    it 'should not receive anything after stopped' do
      expect do
        Net::HTTP.get(URI('http://127.0.0.1:8080/'))
      end.to raise_error(Errno::ECONNREFUSED)
    end

    it 'should not stop after stopped' do
      expect(Midori.stop).to eq(false)
    end
  end
end