require './spec/spec_helper'

RSpec.describe Midori::Runner do
  describe 'Runner with default configure' do
    subject { Midori::Runner.new(EXAMPLE_API_ENGINE, ExampleConfigure) }

    after {
      subject.stop
    }

    it 'should not stop before started' do
      expect(subject.stop).to eq(false)
    end

    it 'should start properly' do
      expect do
        Thread.new { subject.start }
        sleep 1
      end.to_not raise_error(RuntimeError)
    end
  end

  describe 'Running runner' do
    subject { Midori::Runner.new(EXAMPLE_API_ENGINE, ExampleConfigure) }

    before do
      Thread.new { subject.start }
      sleep 1
    end

    it 'should stop properly' do
      expect(subject.stop).to eq(true)
    end

    it 'should not receive anything after stopped' do
      expect do
        subject.stop
        puts Net::HTTP.get(URI('http://127.0.0.1:8080/'))
        Net::HTTP.get(URI('http://127.0.0.1:8080/'))
      end.to raise_error(Errno::ECONNREFUSED)
    end
  end
end
