class Midori::Postgres
  def initialize(socket)
    @db = EM.connect_unix_domain(socket)
  end

  def connect(dbname, username, password)
    Promise.new(->(resolve, _reject) {
      @db.connect(dbname, username, password).callback do |status|
        resolve.call(status)
      end
    })
  end
end

# EM.run do
#   db = EM.connect_unix_domain( "/tmp/.s.PGSQL.5432", EM::P::Postgres3 ) 
#   db.connect( dbname, username, psw ).callback do |status| 
#     if status 
#       db.query( "select * from some_table" ).callback do |status, result, errors| 
#         if status 
#           result.rows.each do |row| 
#             p row 
#           end 
#         end 
#       end 
#     end 
#   end 
# end
