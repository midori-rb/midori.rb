require './spec/spec_helper'
require 'em-midori/extension/file'

RSpec.describe Midori::File do
  describe 'read file' do
    it 'should read file in correct order' do
      answer = []
      async :test_file_read do
        answer << Midori::File.read('./Rakefile')
        EM.stop
      end
      EM.run {
        test_file_read
        answer << 0
      }
      expect(answer).to eq([0, File.read('./Rakefile')])
    end

    it 'raise error when read failed' do
      async :test_file_read do
        Midori::File.read('./TooYoungTooSimple')
        EM.stop
      end
      expect { EM.run {
        test_file_read
      } }.to raise_error(Errno::ENOENT)
    end
  end
end
