class Midori::Connection
  include Midori::Server

  attr_accessor :data

  def initialize(socket)
    @registered = false
    @socket = socket
    @monitor = nil
    @close_flag = false
    @data = ''
    listen(socket)
  end

  def listen(socket)
    EventLoop.register(socket, :rw) do |monitor|
      @monitor = monitor
      if monitor.readable?
        receive_data(monitor)
      end
      if monitor.writable?
        if !@data.empty?
          # :nocov:
          # Leave for corner cases
          monitor.io.write_nonblock(@data)
          @data = ''
          # :nocov:
        elsif @close_flag
          close_connection
        end
      end
    end
  end

  def send_data(data)
    @monitor.writable? ? @socket.write_nonblock(data) : @data << data
  end

  def close_connection
    EventLoop.deregister @socket
    @socket.close
  end

  def close_connection_after_writing
    @close_flag = true
  end
end