require './spec/spec_helper'
require 'midori/extension/hiredis'
require 'ohm'

RSpec.describe Ohm do
  describe 'driver' do
    it 'should set a value and read it' do
      answer = []
      async :test_redis do
        Ohm.redis = Redic.new
        Ohm.redis.call 'SET', 'foo', 'bar'
        answer << Ohm.redis.call('GET', 'foo')
        EventLoop.stop
      end
      test_redis
      answer << 0
      EventLoop.start
      expect(answer).to eq([0, 'bar'])
    end
  end
end
