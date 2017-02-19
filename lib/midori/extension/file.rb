class Midori::File
  def initialize(*args)
    @file = File.new(*args)
  end

  def read
    await(Promise.new do |resolve|
      data = ''
      EventLoop.register(@file, :r) do
        data << @file.read_nonblock(16384)
        if @file.eof?
          EventLoop.unregister(@file)
          resolve.call(data)
        end
      end
    end)
  end

  def write(data)
    await(Promise.new do |resolve|
      EventLoop.register(@file, :w) do
        EventLoop.unregister(@file)
        resolve.call(@file.write_nonblock(data))
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