safe_require 'sequel', 'gem install sequel'
require 'sequel/adapters/mysql2'

# Management of MySQL Sockets
MYSQL_SOCKETS = {}

##
# Meta-programming Sequel for async extensions
module Sequel
  # Midori Extension of sequel MySQL through meta programming
  module Mysql2
    # Midori Extension of sequel MySQL through meta programming
    class Database
      # Execute the given SQL on the given connection.  If the :type
      # option is :select, yield the result of the query, otherwise
      # yield the connection if a block is given.
      # @param [Mysql2::Client] conn connection to database
      # @param [String] sql sql query
      # @param [Hash] opts optional options
      # @return [Mysql2::Result] MySQL results
      def _execute(conn, sql, opts) # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
        begin
          # :nocov:
          stream = opts[:stream]
          if NativePreparedStatements
            if (args = opts[:arguments])
              args = args.map{|arg| bound_variable_value(arg)}
            end

            case sql
              when ::Mysql2::Statement
                stmt = sql
              when Dataset
                sql = sql.sql
                close_stmt = true
                stmt = conn.prepare(sql)
            end
          end

          r = log_connection_yield((log_sql = opts[:log_sql]) ? sql + log_sql : sql, conn, args) do
            if stmt
              conn.query_options.merge!(cache_rows: true,
                                        database_timezone: timezone,
                                        application_timezone: Sequel.application_timezone,
                                        stream: stream,
                                        cast_booleans: convert_tinyint_to_bool)
              stmt.execute(*args)
              # :nocov:
            else
              if MYSQL_SOCKETS[conn.socket].nil?
                MYSQL_SOCKETS[conn.socket] = IO::open(conn.socket)
              end
              socket = MYSQL_SOCKETS[conn.socket]
              await(Promise.new do |resolve|
                count = 0
                EventLoop.register(socket, :rw) do
                  if (count == 0)
                    # Writable
                    count += 1
                    conn.query(sql,
                              database_timezone: timezone,
                              application_timezone: Sequel.application_timezone,
                              stream: stream,
                              async: true)
                  else
                    # Readable
                    begin
                      EventLoop.deregister(socket)
                      resolve.call(conn.async_result)
                    rescue ::Mysql2::Error => e
                      resolve.call(PromiseException.new(e))
                      next
                    end
                  end
                end
              end)
            end
          end

          # :nocov:
          if opts[:type] == :select
            if r
              if stream
                begin
                  r2 = yield r
                ensure
                  # If r2 is nil, it means the block did not exit normally,
                  # so the rest of the results must be drained to prevent
                  # "commands out of sync" errors.
                  r.each{} unless r2
                end
              else
                yield r
              end
            end
          elsif block_given?
            yield conn
          end
        rescue ::Mysql2::Error => e
          raise_error(e)
        ensure
          if stmt
            conn.query_options.replace(conn.instance_variable_get(:@sequel_default_query_options))
            stmt.close if close_stmt
          end
          # :nocov:
        end
      end
    end
  end
end
