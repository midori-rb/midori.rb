require './spec/spec_helper'
require 'midori/extension/file'

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

    it 'should write file in correct order' do
      answer = []
      async :test_file_write do
        answer << Midori::File.write('/tmp/SometimesNaive', 'hello')
        EM.stop
      end
      EM.run {
        test_file_write
        answer << 0
      }
      expect(answer).to eq([0, 5])
    end

    it 'raise error when write failed' do
      async :test_file_write do
        Midori::File.write('/tmp/SometimesNaive', 'hello', {mode: 'r'})
        EM.stop
      end
      expect { EM.run {
        test_file_write
      } }.to raise_error(IOError)
    end
  end
end
