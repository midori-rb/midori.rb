safe_require 'sequel', 'gem install sequel'
require 'sequel/adapters/postgres'

# Management of Postgres Sockets
POSTGRES_SOCKETS = {}

##
# Midori Extension of sequel postgres through meta programming
class Sequel::Postgres::Adapter
  # Call a sql request asynchronously
  # @param [String] sql sql request
  # @param [Array] args args to send
  # @return [Array] sql query result
  def execute_query(sql, args)
    @db.log_connection_yield(sql, self, args) do
      if POSTGRES_SOCKETS[self].nil?
        POSTGRES_SOCKETS[self] = IO::open(socket)
      end
      socket_object = POSTGRES_SOCKETS[self]
      await(Promise.new do |resolve|
        count = 0
        EventLoop.register(socket_object, :rw) do
          begin
            if (count == 0)
              # Writable
              unless is_busy
                send_query(sql)
                count += 1
              end
            else
              # Readable
              EventLoop.deregister(socket_object)
              resolve.call(get_result)
            end
          # For extra errors
          # :nocov:
          rescue => e
            resolve.call(PromiseException.new(e))
          # :nocov:
          end
        end
      end)
    end
  end
end
