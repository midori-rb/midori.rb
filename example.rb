require './lib/midori'
require 'sequel'
require 'mysql2'
require './lib/midori/extension/sequel/mysql2'
require 'json'

Midori::Configure.before = proc do
  DB = Sequel.connect('mysql2://travis@localhost:5432/travis_ci_test')
  class Test < Sequel::Model;end
end

class API < Midori::API
  get '/' do
    Test.all.to_json
  end
end

Midori::Runner.new(API).start
