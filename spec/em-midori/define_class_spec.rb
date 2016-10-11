require 'em-midori'
require './spec/spec_helper'

RSpec.describe Kernel do
  describe 'Define Class' do
    it 'should defined an Error to be caught' do
      define_class('HelloError', StandardError)
      expect do
        raise HelloError
      end.to raise_error(HelloError)
    end
  end
end
