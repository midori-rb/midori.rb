require 'midori/extension/redis'

RSpec.describe 'Redis' do
  describe 'connection' do
    it 'set a simple cache and get it' do
      answer = []
      async :test_redis do
        redis = Midori::Redis.new
        redis.set 'foo', 'bar'
        answer << redis.get('foo')
        EM.stop
      end

      EM.run {
        test_redis
        answer << 0
      }
      expect(answer).to eq([0, 'bar'])
    end

    it 'returns raw pubsub' do
      answer = []
      async :test_redis_pubsub do
        redis = Midori::Redis.new
        answer << redis.pubsub.class
        EM.stop
      end

      EM.run {
        test_redis_pubsub
      }
      expect(answer).to eq([EventMachine::Hiredis::PubsubClient])
    end
  end
end
