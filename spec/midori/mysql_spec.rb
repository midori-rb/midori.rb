require 'midori/extension/sequel/mysql2'

RSpec.describe 'Sequel' do
  describe 'MySQL' do
    it 'do query' do
      answer = []
      async :test_mysql do
        @mysql = Sequel.connect('mysql2://travis@localhost:5432/travis_ci_test')

        @mysql.run <<-SQL
          DROP TABLE IF EXISTS tests;
        SQL

        @mysql.run <<-SQL
          CREATE TABLE IF NOT EXISTS tests (
            id SERIAL,
            title varchar(64),
            PRIMARY KEY(id)
          );
        SQL

        class Test < Sequel::Model(@mysql[:tests])
        end

        test = Test.new
        test.title = 'test'
        test.save

        Test.where(title: 'test').each { |r|
          answer << r.title
        }

        EventLoop.stop
      end

      test_mysql
      answer << 0
      EventLoop.start

      expect(answer).to eq([0, 'test'])
    end
  end
end
