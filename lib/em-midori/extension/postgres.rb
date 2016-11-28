class Midori::Postgres
  def initialize(socket, port = nil)
    @db = port.nil? ? EM.connect_unix_domain(socket) : EM.connect(socket, port)
    
  end

  def connect(dbname, username, password)
    await(Promise.new(->(resolve, _reject) {
      @db.connect(dbname, username, password).callback do |status|
        resolve.call(status)
      end
    }))
  end

  def query(sql)
    await(Promise.new(->(resolve, _reject) {
      @db.query(sql).callback do |status, result, errors|
        status ? resolve.call(result) : raise(errors[-1])
      end
    }))
  end
end
