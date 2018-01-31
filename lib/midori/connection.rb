##
# States of a connection
class Midori::Connection
  include Midori::Server

  # @!attribute data
  #   @return [String] string buffer of data to send
  attr_accessor :data

  # Init Connection with socket
  # @param [IO] socket raw socket
  def initialize(socket)
    @registered = false
    @socket = socket
    @monitor = nil
    @close_flag = false
    @buffer = ''
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
        if !@buffer.empty?
          send_buffer
        elsif @close_flag
          close_connection
        end
      end
    end
  end

  # Send message to client
  # @param [Midori::Response | String] data data to send
  def send_data(data)
    @buffer << (data.is_a?(String) ? data : data.to_s)
    send_buffer if @monitor.writable?
    nil
  end

  # Send buffer immediately
  private def send_buffer
    written = @socket.write_nonblock(@buffer)
    @buffer = @buffer.byteslice(written..-1)
    nil
  rescue => _e
    # Ignore connection closed when writing
    close_connection
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
