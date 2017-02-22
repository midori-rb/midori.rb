require 'net/protocol'

class Net::BufferedIO
  def rbuf_fill
    case rv = @io.read_nonblock(BUFSIZE, exception: false)
      when String
        return @rbuf << rv
      when :wait_readable
        await(Promise.new do |resolve|
          EventLoop.register(@io.to_io, :r) do
            EventLoop.unregister(@io.to_io)
              resolve.call(self)
          end
        end)
        # @io.to_io.wait_readable(@read_timeout) or raise Net::ReadTimeout
      # continue looping
      when :wait_writable
        # OpenSSL::Buffering#read_nonblock may fail with IO::WaitWritable.
        # http://www.openssl.org/support/faq.html#PROG10
        # :nocov:
        await(Promise.new do |resolve|
          EventLoop.register(@io.to_io, :w) do
            EventLoop.unregister(@io.to_io)
            resolve.call(self)
          end
        end)
        # @io.to_io.wait_writable(@read_timeout) or raise Net::ReadTimeout
      # continue looping
      when nil
        # callers do not care about backtrace, so avoid allocating for it
        raise EOFError, 'end of file reached', []
        # :nocov:
    end while true
  end
end