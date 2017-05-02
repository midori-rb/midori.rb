require './spec/spec_helper'
require 'midori/extension/net'
require 'net/http'

RSpec.describe Net::HTTP do
  describe 'HTTP' do
    it 'should request http request correctly' do
      answer = []
      async :test_http do
        res1 = Net::HTTP.get_response(URI('https://github.com/'))
        res2 = Net::HTTP.get_response(URI('https://github.com/'))
        answer << res1.code
        answer << res2.code
        EventLoop.stop
      end
      test_http
      answer << 0
      EventLoop.start
      expect(answer).to eq([0, '200', '200'])
    end
  end
end
