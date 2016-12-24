safe_require 'sequel', 'gem install sequel'
require 'sequel/adapters/postgres'

##
# Midori Extension of sequel postgres through meta programming
class Sequel::Postgres::Adapter
  # Call a sql request asynchronously
  # @param [ String ] sql sql request
  # @param [ Array ] args args to send
  # @return [ Array ] sql query result
  def execute_query(sql, args)
    @db.log_connection_yield(sql, self, args) do
      args ? await(defer{async_exec(sql, args)}) : await(defer{async_exec(sql)})
    end
  end
end
