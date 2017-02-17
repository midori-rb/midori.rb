require './spec/spec_helper'

RSpec.describe Promise do
  describe 'async await' do
    it 'should deal async requests correctly' do
      def read_file(file)
        Promise.new do |resolve|
          file = File.open(file, 'r')
          EventLoop.register(file, :r) do |monitor|
            data = file.read_nonblock(16384)
            EventLoop.unregister(monitor)
            resolve.call(data)
          end
        end
      end
      answer = []
      async :async_read do
        data = await read_file('./Rakefile')
        answer << 1
        answer << data
        EventLoop.stop
      end
      async_read
      answer << 0
      EventLoop.start
      expect(answer).to eq([0, 1, File.read('./Rakefile')])
    end
  end
end
