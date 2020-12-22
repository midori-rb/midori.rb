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
    @socket = socket[0]
    @peer_addr = socket[1].ip_unpack
    @close_flag = false
    @buffer = ''
  end

  # Register events of connection
  # @param [Array] socket raw socket
  def listen
    Fiber.schedule do
      until @socket.closed?
        receive_data(@socket)
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
    @socket.write(@buffer) unless @socket.closed?
    nil
  end

  # Close the connection
  # @return [nil] nil
  def close_connection
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
