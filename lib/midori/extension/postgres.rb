safe_require 'postgres-pr/message', 'gem install postgres-pr'

##
# Midori Extension for Postgres Driver
# @attr [ Fixnum ] connected Connection Status
class Midori::Postgres
  attr_reader :connected

  def initialize(*args)
    @connected = false
    @db = EM.connect(*args, EM::P::Postgres3)
  end

  # Connect the Postgres server
  # @param [ String ] db_name database name
  # @param [ String ] username username
  # @param [ password ] password password
  # @return [ nil ] nil
  def connect(db_name, username, password)
    await(Promise.new(->(resolve, _reject) {
      @db.connect(db_name, username, password).callback do |status|
        @connected = status
        resolve.call(status)
      end
    }))
  end

  # Make SQL query
  # @param [ String ] sql sql query
  # @return [ Midori::Postgres::Result ] query result
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

##
# Postgres Result for Midori Postgres Driver Extension
# @param [ Array ] result result if success
# @param [ Array ] errors exceptions met
class Midori::Postgres::Result
  attr_reader :result, :errors
  def initialize(result, errors)
    @result = result
    @errors = errors
  end
end
