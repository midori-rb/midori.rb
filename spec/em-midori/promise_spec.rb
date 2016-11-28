require './spec/spec_helper'

RSpec.describe Promise do
  describe 'async await' do
    it 'should deal aync requests correctly' do
      def asleep(sec)
        Promise.new(->(resolve, _reject) {
          EM.add_timer(sec) do
            resolve.call('+' + sec.to_s + 's')
          end
        })
      end
      answer = []
      async :async_sleep do
        await asleep(1)
        answer << 1
        EM.stop
      end
      EM.run {
        async_sleep
        answer << 0
      }
      expect(answer).to eq([0, 1])
    end
  end
end
