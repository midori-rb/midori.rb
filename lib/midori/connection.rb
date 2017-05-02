##
# States of a connection
class Midori::Connection
  include Midori::Server

  # @!attribute data
  #   @return [String] string buffer of data to send
  attr_accessor :data

  # @param [IO] socket raw socket
  def initialize(socket)
    @registered = false
    @socket = socket
    @monitor = nil
    @close_flag = false
    @data = ''
    listen(socket)
  end

  # Register events of connection
  # @param [IO] socket raw socket
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

  # Send message to client
  # @param [String] data data to send
  def send_data(data)
    @monitor.writable? ? @socket.write_nonblock(data) : @data << data
  end

  # Close the connection
  def close_connection
    EventLoop.deregister @socket
    @socket.close
  end

  # Close the connection after writing
  def close_connection_after_writing
    @close_flag = true
  end
end
