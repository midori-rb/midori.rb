require 'net/protocol'

class Net::BufferedIO
  def wait_io(interest)
    await(Promise.new do |resolve|
      io = @io.to_io
      EventLoop.register(io, interest) do
        EventLoop.deregister(io)
        resolve.call(self)
      end
    end)
  end

  def rbuf_fill
    loop do
      case rv = @io.read_nonblock(BUFSIZE, exception: false)
        when String
          return @rbuf << rv
        when :wait_readable
          wait_io(:r)
        # @io.to_io.wait_readable(@read_timeout) or raise Net::ReadTimeout
        # continue looping
        when :wait_writable
          # OpenSSL::Buffering#read_nonblock may fail with IO::WaitWritable.
          # http://www.openssl.org/support/faq.html#PROG10
          # :nocov:
          wait_io(:w)
        # @io.to_io.wait_writable(@read_timeout) or raise Net::ReadTimeout
        # continue looping
        when nil
          # callers do not care about backtrace, so avoid allocating for it
          raise EOFError, 'end of file reached', []
        # :nocov:
      end
    end
  end
end
