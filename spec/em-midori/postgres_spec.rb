require './spec/spec_helper'
require 'em-midori/extension/postgres'

RSpec.describe Midori::Postgres do
  describe 'postgres' do
    it 'should connect in correct order' do
      answer = []
      async :test_postgres do
        @db = Midori::Postgres.new('127.0.0.1', 5432)
        answer << @db.connect('travis_ci_test', 'postgres', '')
        EM.stop
      end
      EM.run {
        test_postgres
        answer << 0
      }
      expect(answer).to eq([0, true])
    end

    it 'should query in correct order' do
      answer = []
      async :test_postgres do
        @db = Midori::Postgres.new('127.0.0.1', 5432)
        @db.connect('travis_ci_test', 'postgres', '')
        answer << (@db.query <<-SQL
          CREATE TABLE IF NOT EXISTS foo (
            bar varchar(45)
          )
        SQL
        ).result.cmd_tag
        EM.stop
      end
      EM.run {
        test_postgres
        answer << 0
      }
      expect(answer).to eq([0, 'CREATE TABLE'])
    end

    it 'should raise error when failed' do
      answer = []
      async :test_postgres do
        @db = Midori::Postgres.new('127.0.0.1', 5432)
        @db.connect('travis_ci_test', 'postgres', '')
        answer << true unless (@db.query <<-SQL
            SYNTAX ERROR TEST
        SQL
        ).errors.empty?
        EM.stop
      end
      EM.run {
        test_postgres
        answer << 0
      }
      expect(answer).to eq([0, true])
    end
  end
end
