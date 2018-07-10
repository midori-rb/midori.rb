##
# This class provides methods for WebSocket connection instance.
# @attr [Array<Integer>, String] msg message send from client
# @attr [Integer] opcode operation code of WebSocket
# @attr [Hash] events response for different event
# @attr [Midori::Connection] connection raw EventMachine connection
# @attr [Midori::Request] request raw request
class Midori::WebSocket
  attr_accessor :msg, :opcode, :events, :connection, :request

  # Init a WebSocket instance with a connection
  # @param [Midori::Connection] connection raw EventMachine connection
  def initialize(connection)
    @events = {}
    @connection = connection
  end

  # API definition for events
  # @param [Symbol] event event name(open, message, close, ping, pong)
  # @yield what to do after event matched
  # @example
  #   websocket '/websocket' do |ws|
  #     ws.on :message do |msg|
  #       puts msg
  #     end
  #   end
  def on(event, &block) # open, message, close, ping, pong
    @events[event] = block
  end

  # Send data
  # @param [Array<Integer>, String] msg data to send
  def send(msg)
    output = []
    if msg.is_a?String
      output << 0b10000001 << msg.size << msg
      @connection.send_data(output.pack("CCA#{msg.size}"))
    elsif msg.is_a? Array
      output << 0b10000010 << msg.size
      output.concat msg
      @connection.send_data(output.pack('C*'))
    else
      raise Midori::Exception::OpCodeError
    end
  end

  # Send a Ping request
  # @param [String] str string to send
  def ping(str)
    heartbeat(0b10001001, str)
  end

  # Send a Pong request
  # @param [String] str string to send
  def pong(str)
    heartbeat(0b10001010, str)
  end

  # Ancestor of ping pong
  # @param [Integer] method opcode
  # @param [String] str string to send
  def heartbeat(method, str)
      raise Midori::Exception::PingPongSizeTooLarge if str.size > 125
      @connection.send_data [method, str.size, str].pack("CCA#{str.size}")
  end

  # Close a websocket connection
  def close
    raise Midori::Exception::FrameEnd
  end
end
