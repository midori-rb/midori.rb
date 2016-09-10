require 'em-midori'
require './spec/spec_helper'
require 'net/http'


RSpec.describe Midori do
  describe 'Start Server' do
    it 'should start properly' do
      expect {
        Thread.new { Midori.run(Midori::API, '127.0.0.1', 8080) }
      }.to_not raise_error(RuntimeError)
    end

    it 'should return \'Hello World\' on any response' do
      expect(Net::HTTP.get(URI('http://127.0.0.1:8080/'))).to eq('Hello World')
    end
  end
end