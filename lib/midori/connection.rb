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
      receive_data(monitor) if monitor.readable?
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
    send_buffer
    nil
  end

  # Send buffer immediately
  # @return [nil] nil
  private def send_buffer
    if @monitor.writable?
      written = @socket.write_nonblock(@buffer)
      @buffer = @buffer.byteslice(written..-1)
    end
    nil
  rescue IO::EAGAINWaitWritable => _e
    # :nocov:
    # Unknown Reason Resource Conflict
    nil
    # :nocov:
  end

  # Close the connection
  # @return [nil] nil
  def close_connection
    EventLoop.remove_timer(@keep_alive_timer) unless @keep_alive_timer.nil? # Be sure to remove timer for memory safety
    EventLoop.deregister @socket
    @socket.close
    nil
  end

  # Close the connection after writing
  # @return [nil] nil
  def close_connection_after_writing
    @close_flag = true
    nil
  end
end
