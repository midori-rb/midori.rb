require 'midori/extension/sequel/postgres'

RSpec.describe 'Sequel' do
  describe 'Postgres' do
    it 'do query' do
      answer = []
      async :test_sequel do
        @postgres = Sequel.connect('postgres://postgres@localhost:5432/travis_ci_test')

        @postgres.run <<-SQL
          DROP TABLE IF EXISTS products;
        SQL

        @postgres.run <<-SQL
          CREATE TABLE IF NOT EXISTS products (
            id SERIAL,
            title varchar(64),
            PRIMARY KEY(id)
          );
        SQL

        class Product < Sequel::Model(@postgres[:products])
        end

        product = Product.new
        product.title = 'test'
        product.save

        Product.where(title: 'test').each { |r|
          answer << r.title
        }

        EventLoop.stop
      end

      test_sequel
      answer << 0
      EventLoop.start

      expect(answer).to eq([0, 'test'])
    end
  end
end
