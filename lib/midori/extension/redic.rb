##
# Meta-programming hiredis for redis async extension
module Hiredis
  require 'hiredis/connection'
  # Overwrite with ruby implementation to hook IO
  require 'hiredis/ruby/connection'
  require 'hiredis/ruby/reader'
  # Redis Connection
  Connection = Ruby::Connection
  # Redis Result Reader
  Reader = Ruby::Reader

  ##
  # Meta-programming hiredis for redis async extension
  module Ruby
    ##
    # Meta-programming hiredis for redis async extension
    class Connection
      # do redis query
      # @param [String] data generated string data
      def query(args)
        await(Promise.new do |resolve|
          write_finished = false
          command = []
          command << "*#{args.size}"
          args.each do |arg|
            arg = arg.to_s
            command << "$#{string_size arg}"
            command << arg
          end

          data = command.join(COMMAND_DELIMITER) + COMMAND_DELIMITER

          data.force_encoding('binary') if data.respond_to?(:force_encoding)
          written = 0
          EventLoop.register(@sock, :rw) do |monitor|
            if write_finished && monitor.readable?
              # Reading
              @reader.feed @sock.read_nonblock(1024)
              reply = @reader.gets
              if reply
                EventLoop.deregister(@sock)
                resolve.call(reply)
              end
            elsif !write_finished && monitor.writable?
              # Writing
              written += @sock.write_nonblock(data[written..-1])
              write_finished = true if written == string_size(data)
            end
          end
        end)

      end
    end
  end
end

require 'redic'

class Redic
  class Client
    def connect
      establish_connection unless connected?
      if block_given?
        @semaphore.synchronize do
          yield
        end
      end
    end

    def call(*args)
      @connection.query(*args)
    end
  end

  def call(*args)
    @client.connect
    @client.call(args)
  end
end
