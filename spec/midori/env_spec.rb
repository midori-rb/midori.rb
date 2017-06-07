require './spec/spec_helper'

RSpec.describe Midori do
  describe 'env' do
    it 'should be development by default' do
      expect(Midori.env).to eq('development')
      expect(Midori.env.development?).to eq(true)
      expect(Midori.env.production?).to eq(false)
    end

    it 'should be production after setting env' do
      ENV['MIDORI_ENV'] = 'production'
      expect(Midori.env).to eq('production')
      expect(Midori.env.development?).to eq(false)
      expect(Midori.env.production?).to eq(true)
    end
  end
end
