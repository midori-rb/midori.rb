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
        @db.query(sql).callback do |_status, result, errors|
          errors.empty? ? resolve.call(result) : resolve.call(PromiseException.new(errors))
        end
      end
    }))
  end
end