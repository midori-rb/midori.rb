##
# Midori Extension of File reading and writing
class Midori::File
  # Init File object
  # @param [Array] args same args like File.new
  def initialize(*args)
    @file = File.new(*args)
  end

  # read file
  # @return [String] string readed
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

  # write file
  # @param [String] data string to be written
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

  # raw file object
  # @return [File] file
  def raw
    @file
  end

  # Close the file
  def close
    @file.close
  end
end
