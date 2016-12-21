require 'midori/extension/ohm'

RSpec.describe 'Ohm' do
  describe 'connection' do
    it 'set a simple cache and get it' do
      answer = []
      async :test_ohm do
        Ohm.redis = Redic.new
        Ohm.redis.call 'SET', 'Foo', 'Bar' 
        answer << Ohm.redis.call('GET', 'Foo')
        EM.stop
      end

      EM.run {
        test_ohm
        answer << 0
      }
      expect(answer).to eq([0, 'Bar'])
    end
  end
end
