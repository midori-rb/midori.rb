require './spec/spec_helper'

RSpec.describe HTTPHeader do
  describe 'HTTPHeader' do
    it 'should turn strings and symbols downcase' do
      hash = HTTPHeader.new
      hash['A'] = 1
      hash[:A] = 2
      expect(hash.keys).to eq(['a', :a])
    end

    it 'should respond hash key in any case' do
      hash = HTTPHeader.new
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

    it 'should not use keys other than string or symbol' do
      hash = HTTPHeader.new
      expect { hash[true] = 1 }.to raise_error(NoMethodError)
    end
  end
end
