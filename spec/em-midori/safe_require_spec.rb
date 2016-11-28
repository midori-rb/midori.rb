require './spec/spec_helper'

RSpec.describe Kernel do
  describe 'safe require' do
    it 'raise prompt when file not found' do
      expect {safe_require 'UNKNOWN_FILE', 'prompt'}.to raise_error('prompt')
    end
  end
end
