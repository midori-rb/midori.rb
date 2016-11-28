class Midori::Postgres
  def initialize(*args)
    @db = EM.connect(*args, EM::P::Postgres3)
  end

  def connect(db_name, username, password)
    await(Promise.new(->(resolve, _reject) {
      @db.connect(db_name, username, password).callback do |status|
        resolve.call(status)
      end
    }))
  end

  def query(sql)
    await(Promise.new(->(resolve, _reject) {
      begin
        @db.query(sql).callback do |status, result, errors|
          resolve.call(Midori::Postgres::Result.new(status, result, errors))
        end
      rescue Exception => e
        resolve.call(PromiseException.new(e))
      end
    }))
  end
end

class Midori::Postgres::Result
  attr_reader :status, :result, :errors
  def initialize(status, result, errors)
    @status = status
    @result = result
    @errors = errors
  end
end
