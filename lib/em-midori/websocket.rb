class Midori::WebSocket
    attr_accessor :fin, :opcode, :msg, :events
    def initialize
        @events = Hash.new
    end
    def decode_mask(data)
        # Fin and Opcode
        byte_tmp = data.getbyte
        @fin = byte_tmp & 0b10000000
        @opcode = byte_tmp & 0b00001111
        raise ContinuousFrameError unless fin
        raise OpCodeError unless [1, 2, 7, 8].include?opcode
        # TODO: Implement ping&pong later
        # Mask
        byte_tmp = data.getbyte
        is_masked = byte_tmp & 0b10000000
        raise NotMaskedError unless is_masked
        # Payload
        payload = byte_tmp & 0b01111111
        mask = 4.times.map {data.getbyte}
        # Message
        masked_msg = payload.times.map {data.getbyte}
        @msg = masked_msg.each_with_index.map {|byte, i| byte ^ mask[i % 4]}
        @msg = @msg.pack('C*').force_encoding('utf-8') if @opcode == 1
    end

    def on(event, &block) # open, message, close
        @events[event] = block
    end
end