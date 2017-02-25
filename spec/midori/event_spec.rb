require './spec/spec_helper'

RSpec.describe EventLoop do
  describe EventLoop::Timer do
    it 'should get timed after 1 second' do
      answer = []
      timer = EventLoop::Timer.new(1) do
        answer << 1
        EventLoop.stop
      end
      EventLoop.add_timer(timer)
      answer << 0
      EventLoop.start
      expect(answer).to eq([0, 1])
    end
  end
end
