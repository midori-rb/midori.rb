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

    it 'query something illegal' do
      async :test_mysql do
        expect {
          @mysql = Sequel.connect('mysql2://travis@localhost:5432/travis_ci_test')
          @mysql.run <<-SQL
            SELECT * FROM NOWHERE;
          SQL
        }.to raise_error(Sequel::DatabaseError)
        EventLoop.stop
      end
      test_mysql
      EventLoop.start
    end

    it 'query acync' do
      expect do
        @answer = []
        @mysql = Sequel.connect('mysql2://travis@localhost:5432/travis_ci_test')
        async :test_mysql do
          @answer << (@mysql.run <<-SQL
            SELECT COUNT(*) FROM tests;
          SQL
          )
          EventLoop.stop if @answer.length == 10
        end
        10.times { test_mysql }
        EventLoop.start
      end.to_not raise_error(RuntimeError)
    end
  end
end
