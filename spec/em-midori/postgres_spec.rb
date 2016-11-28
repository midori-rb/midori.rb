require './spec/spec_helper'
require 'em-midori/extension/postgres'

RSpec.describe Midori::Postgres do
  describe 'postgres' do
    it 'should query in correct order' do
      answer = []
      async :test_postgres do
        @db = Midori::Postgres.new('127.0.0.1', 5432)
        answer << @db.connect('travis_ci_test', 'postgres', '')
        answer << (@db.query <<-SQL
          CREATE TABLE IF NOT EXISTS foo (
            bar varchar(45)
          )
        SQL
        ).cmd_tag

        begin
          @db.query <<-SQL
            SYNTAX ERROR TEST
          SQL
        rescue => _e
          answer << true
        end

        EM.stop
      end
      EM.run {
        test_postgres
        answer << 0
      }
      expect(answer).to eq([0, true, 'CREATE TABLE', true])
    end
  end
end
