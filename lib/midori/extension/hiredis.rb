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
      # write message directly
      # @param [IO] _sock raw socket
      # @param [String] data generated string data
      # @param [Float] _timeout operation timeout
      def _write(_sock, data, _timeout)
        await(Promise.new do |resolve|
          data.force_encoding('binary') if data.respond_to?(:force_encoding)
          written = 0
          EventLoop.register(@sock, :w) do
            written += @sock.write_nonblock(data[written..-1])
            if written == string_size(data)
              EventLoop.deregister(@sock)
              resolve.call
            end
          end
        end)
      end

      # read from redis socket
      # @return [String] reply
      def read
        raise 'not connected' unless connected?
        await(Promise.new do |resolve|
          EventLoop.register(@sock, :r) do
            @reader.feed @sock.read_nonblock(1024)
            reply = @reader.gets
            if reply
              EventLoop.deregister(@sock)
              resolve.call(reply)
            end
          end
        end)
      rescue ::EOFError
        # :nocov:
        # Error Handler Copied from HiRedis driver itself
        raise Errno::ECONNRESET
        # :nocov:
      end
    end
  end
end
