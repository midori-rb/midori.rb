##
# This class provides methods for WebSocket connection instance.
# @attr [ Array<Fixnum>, String ] msg message send from client
# @attr [ Fixnum ] opcode operation code of WebSocket
# @attr [ Hash ] events response for different event
# @attr [ EM::Connection ] connection raw EventMachine connection
# @attr [ Midori::Request ] request raw request
class Midori::WebSocket
  attr_accessor :msg, :opcode, :events, :connection, :request

  # Init a WebSocket instance with a connection
  # @param [ EM::Connection ] connection raw EventMachine connection
  def initialize(connection)
    @events = {}
    @connection = connection
  end

  # Decode raw data send from client
  # @param [ StringIO ] data raw data
  def decode(data)
    # Fin and Opcode
    byte_tmp = data.getbyte
    fin = byte_tmp & 0b10000000
    @opcode = byte_tmp & 0b00001111
    # NOT Support Multiple Fragments
    raise Midori::Exception::ContinuousFrame unless fin
    raise Midori::Exception::OpCodeError unless [0x1, 0x2, 0x8, 0x9, 0xA].include? opcode
    close if @opcode == 0x8 # Close Frame
    # return if @opcode == 0x9 || @opcode == 0xA # Ping Pong
    decode_mask(data)
  end

  # Decode masked message send from client
  # @param [ StringIO ] data raw data
  def decode_mask(data)
    # Mask
    byte_tmp = data.getbyte
    is_masked = byte_tmp & 0b10000000
    raise Midori::Exception::NotMasked unless is_masked == 128
    # Payload
    payload = byte_tmp & 0b01111111
    mask = Array.new(4) { data.getbyte }
    # Message
    masked_msg = Array.new(payload) { data.getbyte }
    @msg = masked_msg.each_with_index.map { |byte, i| byte ^ mask[i % 4] }
    @msg = @msg.pack('C*').force_encoding('utf-8') if [0x1, 0x9, 0xA].include?opcode
    # For debug
    #  data.rewind
    #  data.bytes {|byte| puts byte.to_s(16)}
  end

  # API definition for events
  # @param [ Symbol ] event event name(open, message, close, ping, pong)
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
  # @param [ Array<Fixnum>, String ] msg data to send
  def send(msg)
    output = []
    if msg.is_a?String
      output << 0b10000001 << msg.size << msg
      @connection.send_data(output.pack("CCA#{msg.size}"))
    elsif msg.is_a?Array
      output << 0b10000010 << msg.size
      output.concat msg
      @connection.send_data(output.pack('C*'))
    else
      raise Midori::Exception::OpCodeError
    end
  end

  # Send a Ping request
  # @param [ String ] str string to send
  def ping(str)
    heartbeat(0b10001001, str)
  end

  # Send a Pong request
  # @param [ String ] str string to send
  def pong(str)
    heartbeat(0b10001010, str)
  end

  # Ancestor of ping pong
  # @param [ Fixnum ] method opcode
  # @param [ String ] str string to send
  def heartbeat(method, str)
      raise Midori::Exception::PingPongSizeTooLarge if str.size > 125
      @connection.send_data [method, str.size, str].pack("CCA#{str.size}")
  end

  # Close a websocket connection
  def close
    raise Midori::Exception::FrameEnd
  end
end
