class Midori::File
  def initialize(*args)
    @file = File.new(*args)
  end

  def read
    await(Promise.new do |resolve|
      data = ''
      EventLoop.register(@file, :r) do
        if @file.eof?
          EventLoop.deregister(@file)
          resolve.call(data)
        else
          data << @file.read_nonblock(16384)
        end
      end
    end)
  end

  def write(data)
    await(Promise.new do |resolve|
      written = 0
      EventLoop.register(@file, :w) do
        written += @file.write_nonblock(data[written..-1])
        if written == data.size
          EventLoop.deregister(@file)
          resolve.call(written)
        end
      end
    end)
  end

  def raw
    @file
  end

  def close
    @file.close
  end
end