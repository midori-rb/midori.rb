safe_require 'sequel', 'gem install sequel'
require 'sequel/adapters/postgres'

##
# Midori Extension of sequel postgres through meta programming
class Sequel::Postgres::Adapter
  # Call a sql request asynchronously
  # @param [String] sql sql request
  # @param [Array] args args to send
  # @return [Array] sql query result
  def execute_query(sql, args)
      @db.log_connection_yield(sql, self, args) do
        socket_object = IO.for_fd(socket)
        result = await(Promise.new do |resolve|
          EventLoop.register(socket_object, :w) do
            begin
              unless is_busy
                EventLoop.deregister(socket_object)
                send_query(sql)
                resolve.call
              end
            rescue
              resolve.call(PromiseException.new(e))
              next
            end
          end
        end)

        return result unless result.nil?

        await(Promise.new do |resolve|
          consume_input
          EventLoop.register(socket_object, :r) do
            begin
              EventLoop.deregister(socket_object)
              resolve.call(get_result)
            rescue
              resolve.call(PromiseException.new(e))
              next
            end
          end
        end)
      end
  end
end
