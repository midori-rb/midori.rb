require './spec/spec_helper'
require 'em-midori/extension/postgres'

RSpec.describe Midori::Postgres do
  describe 'postgres' do
    it 'should query in correct order' do
      answer = []
      async :test_postgres do
        @db = Midori::Postgres.new('/tmp/.s.PGSQL.5432')
        EM.stop
      end
      EM.run {
        test_postgres
        answer << 0
      }
      expect(answer).to eq([0])
    end
  end
end
