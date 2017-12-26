require './spec/spec_helper'

RSpec.describe CIHash do
  describe 'CIHash' do
    it 'should turn strings and symbols downcase' do
      hash = CIHash.new
      hash['A'] = 1
      hash[:A] = 2
      expect(hash.keys).to eq(['a', :a])
    end

    it 'should respond hash key in any case' do
      hash = CIHash.new
      hash['A'] = 1
      hash[:A] = 2
      expect(hash.key?('a')).to eq(true)
      expect(hash.key?(:a)).to eq(true)
      expect(hash.key?('A')).to eq(true)
      expect(hash.key?(:A)).to eq(true)
      expect(hash['A']).to eq(1)
      expect(hash['a']).to eq(1)
      expect(hash[:A]).to eq(2)
      expect(hash[:a]).to eq(2)
    end

    it 'should key other things as it is' do
      hash = CIHash.new
      hash[true] = 1
      expect(hash[true]).to eq(1)
    end
  end
end
