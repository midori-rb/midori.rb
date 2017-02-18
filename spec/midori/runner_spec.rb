require './spec/spec_helper'

RSpec.describe Midori::Runner do
  describe 'Runner with default configure' do
    subject { EXAMPLE_RUNNER }

    after {
      subject.stop
      sleep 1
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
end
