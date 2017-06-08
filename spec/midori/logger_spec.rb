require './spec/spec_helper'

RSpec.describe Midori do
  describe 'logger' do
    it 'should always get non nil logger' do
      expect(Midori.logger).not_to be(nil)
    end
  end
end
