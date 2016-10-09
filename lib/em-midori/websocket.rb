##
# This class provides methods for WebSocket connection instance.
class Midori::WebSocket
  attr_accessor :msg, :opcode, :events, :connection

  def initialize(connection)
    @events = {}
    @connection = connection
  end

  def decode(data)
    # Fin and Opcode
    byte_tmp = data.getbyte
    fin = byte_tmp & 0b10000000
    @opcode = byte_tmp & 0b00001111
    # NOT Support Multiple Fragments
    raise Midori::Error::ContinuousFrame unless fin
    raise Midori::Error::OpCodeError unless [0x1, 0x2, 0x8, 0x9, 0xA].include?opcode
    close if @opcode == 0x8 # Close Frame
    # return if @opcode == 0x9 || @opcode == 0xA # Ping Pong
    decode_mask(data)
  end

  def decode_mask(data)
    # Mask
    byte_tmp = data.getbyte
    is_masked = byte_tmp & 0b10000000
    raise Midori::Error::NotMasked unless is_masked == 128
    # Payload
    payload = byte_tmp & 0b01111111
    mask = Array.new(4) { data.getbyte }
    # Message
    masked_msg = Array.new(payload) { data.getbyte }
    @msg = masked_msg.each_with_index.map { |byte, i| byte ^ mask[i % 4] }
    @msg = @msg.pack('C*').force_encoding('utf-8') if [0x1, 0x9, 0xA].include?opcode
  end

  def on(event, &block) # open, message, close, ping, pong
    @events[event] = block
  end

  def send(msg)
    output = []
    if msg.is_a?String
      output << 0b10000001 << msg.size << msg
      @connection.send_data(output.pack("CCA#{msg.size}"))
    elsif msg.is_a?Array
      output << 0b10000010 << msg.size
      output.concat msg
      @connection.send_data(output.pack("C*"))
    else
      raise Midori::Error::OpCodeError
    end
  end

  def ping(str)
    heartbeat(0b10001001, str)
  end

  def pong(str)
    heartbeat(0b10001010, str)
  end

  def heartbeat(method, str)
      raise Midori::Error::PingPongSizeTooLarge if str.size > 125
      @connection.send_data [method, str.size, str].pack("CCA#{str.size}")
  end

  def close
    raise Midori::Error::FrameEnd
  end
end
