safe_require 'postgres-pr/message', 'gem install postgres-pr'

class Midori::Postgres
  attr_reader :connected

  def initialize(*args)
    @connected = false
    @db = EM.connect(*args, EM::P::Postgres3)
  end

  def connect(db_name, username, password)
    await(Promise.new(->(resolve, _reject) {
      @db.connect(db_name, username, password).callback do |status|
        @connected = status
        resolve.call(status)
      end
    }))
  end

  def query(sql)
    await(Promise.new(->(resolve, _reject) {
      begin
        @db.query(sql).callback do |status, result, errors|
          @connected = status
          resolve.call(Midori::Postgres::Result.new(result, errors))
        end
      end
    }))
  end
end

class Midori::Postgres::Result
  attr_reader :result, :errors
  def initialize(result, errors)
    @result = result
    @errors = errors
  end
end
