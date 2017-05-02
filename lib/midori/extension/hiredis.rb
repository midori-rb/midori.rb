module Hiredis
  require 'hiredis/connection'
  # Overwrite with ruby implementation to hook IO
  require 'hiredis/ruby/connection'
  require 'hiredis/ruby/reader'
  Connection = Ruby::Connection
  Reader = Ruby::Reader
end

module Hiredis
  module Ruby
    class Connection
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
