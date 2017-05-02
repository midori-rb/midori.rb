require './spec/spec_helper'
require 'midori/extension/hiredis'

RSpec.describe Hiredis do
  describe 'driver' do
    it 'should set a value and read it' do
      answer = []
      async :test_redis do
        redis = Hiredis::Connection.new
        redis.connect('127.0.0.1', 6379)
        redis.write ['SET', 'foo', 'bar']
        answer << redis.read
        redis.write ['GET', 'foo']
        answer << redis.read
        EventLoop.stop
      end
      test_redis
      answer << 0
      EventLoop.start
      expect(answer).to eq([0, 'OK', 'bar'])
    end
  end
end
