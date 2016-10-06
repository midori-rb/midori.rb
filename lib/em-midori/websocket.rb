class Midori::WebSocket
    attr_accessor :msg, :opcode, :events, :connection

    def initialize(connection)
        @events = Hash.new
        @connection = connection
    end

    def decode(data)
        # Fin and Opcode
        byte_tmp = data.getbyte
        fin = byte_tmp & 0b10000000
        @opcode = byte_tmp & 0b00001111
        raise Midori::Error::ContinuousFrame unless fin
        raise Midori::Error::OpCodeError unless [0x1, 0x2, 0x8, 0x9, 0xA].include?opcode
        raise Midori::Error::FrameEnd if @opcode == 0x8 # Close Frame
        return if @opcode == 0x9 || @opcode == 0xA # Ping Pong
        decode_mask(data)
    end

    def decode_mask(data)
        # Mask
        byte_tmp = data.getbyte
        is_masked = byte_tmp & 0b10000000
        raise Midori::Error::NotMasked unless is_masked
        # Payload
        payload = byte_tmp & 0b01111111
        mask = 4.times.map {data.getbyte}
        # Message
        masked_msg = payload.times.map {data.getbyte}
        @msg = masked_msg.each_with_index.map {|byte, i| byte ^ mask[i % 4]}
        @msg = @msg.pack('C*').force_encoding('utf-8') if @opcode == 0x1
    end

    def on(event, &block) # open, message, close, ping, pong
        @events[event] = block
    end

    def send(msg)
        output = Array.new
        if msg.is_a?String
            output << 0b10000001 << msg.size << msg
        elsif msg.is_a?Array
            output << 0b10000010 << msg.size
            output.concat msg
        else
            raise Midori::Error::OpCodeError
        end
        @connection.send_data(output.pack("CCA#{msg.size}"))
    end

    def ping
        @connection.send_data "\t"
    end

    def pong
        @connection.send_data "\n"
    end

    def close
        Midori::Error::FrameEnd
    end
end