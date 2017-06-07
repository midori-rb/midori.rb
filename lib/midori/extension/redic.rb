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
      # Do redis query
      # @param [Array] args equal to Hiredis write args
      def query(args)
        await(Promise.new do |resolve|
          read_flag = false
          data = pre_write(args)
          written = 0
          EventLoop.register(@sock, :rw) do |monitor|
            if read_flag && monitor.readable?
              # Reading
              _read(resolve, @sock)
            end
            if !read_flag && monitor.writable?
              # Writing
              written += @sock.write_nonblock(data[written..-1])
              read_flag = true if written == string_size(data)
            end
          end
        end)
      end

      private
        def pre_write(args)
          command = []
          command << "*#{args.size}"
          args.each do |arg|
            arg = arg.to_s
            command << "$#{string_size arg}"
            command << arg
          end
          data = command.join(COMMAND_DELIMITER) + COMMAND_DELIMITER
          data.force_encoding('binary') if data.respond_to?(:force_encoding)
          data
        end

        def _read(resolve, sock)
          @reader.feed @sock.read_nonblock(1024)
          reply = @reader.gets
          if reply
            EventLoop.deregister(sock)
            resolve.call(reply)
          end
        end
    end
  end
end

require 'redic'

##
# Meta-programming Redic for redis async extension
class Redic
  # Meta-programming Redic for redis async extension
  class Client
    # Connect redis, yield optional
    def connect
      establish_connection unless connected?
      if block_given?
        # Redic default yield
        # :nocov:
        @semaphore.synchronize do
          yield
        end
        # :nocov:
      end
    end
    
    # Call without thread lock
    # @param [Array] args same params as Redic
    def call(*args)
      @connection.query(*args)
    end
  end

  # Call without thread lock
  # @param [Array] args same params as Redic
  def call(*args)
    @client.connect
    @client.call(args)
  end
end
