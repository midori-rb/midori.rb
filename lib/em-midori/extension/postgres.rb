class Midori::Postgres
  def initialize(socket)
    @db = EM.connect_unix_domain(socket)
  end

  def connect(dbname, username, password)
    await(Promise.new(->(resolve, _reject) {
      @db.connect(dbname, username, password).callback do |status|
        resolve.call(status)
      end
    }))
  end

  def query(str)
    await(Promise.new(->(resolve, _reject) {
      @db.query(str).callback do |status, result, errors|
        resolve.call([status, result, errors])
      end
    }))
  end
end
