require 'sequel'

RSpec.describe 'Sequel' do
  describe 'Postgres' do
    it 'do query' do
      answer = []
      async :test_sequel do
        @db = Sequel.connect('postgres://postgres@localhost:5432/travis_ci_test')

        @db.run <<-SQL
          DROP TABLE IF EXISTS products
        SQL

        @db.run <<-SQL
          CREATE TABLE IF NOT EXISTS products (
            id SERIAL,
            title varchar(64),
            PRIMARY KEY(id)
          )
        SQL

        class Product < Sequel::Model
        end

        product = Product.new
        product.title = 'test'
        product.save

        Product.where(title: 'test').each { |r|
          answer << r.title
        }
        EM.stop
      end

      EM.run {
        test_sequel
        answer << 0
      }
      expect(answer).to eq([0, 'test'])
    end
  end
end
