##
# Logic to EventMachine TCP Server, running inside +EM::Connection+
# @!attribute request
#   @return [ Midori::Request ] raw request
# @!attribute api
#   @return [ Class ] inherited from Midori::API
# @!attribute websocket
#   @return [ Midori::WebSocket ] defined websocket instance
# @!attribute eventsource
#   @return [ Midori::EventSource] defined eventsource instance
module Midori::Server
  attr_accessor :request, :api, :websocket, :eventsource

  # Define server behaviour
  # @param [Class] api inherited from Midori::API
  # @param [Logger] logger global logger
  def initialize(api, logger)
    @api = api
    @logger = logger
    @request = Midori::Request.new
    @websocket = Midori::WebSocket.new(self)
    @eventsource = Midori::EventSource.new(self)
  end

  # Logic of receiving data
  # @param [String] data raw data
  def receive_data(data)
    lambda do
      async_internal(Fiber.new do
                       start_time = Time.now
                       port, ip = Socket.unpack_sockaddr_in(get_peername)
                       @request.ip = ip
                       @request.port = port
                       if @request.parsed?
                         websocket_request(StringIO.new(data))
                       else
                         receive_new_request(data)
                       end
                       now_time = Time.now
                       @logger.info "#{@request.ip} - - \"#{@request.method} #{@request.path} HTTP/#{@request.protocol.join('.')}\" #{@response.status} #{(now_time.to_f - start_time.to_f).round(6)}".green
                     end)
    end.call
  end

  # Logic of receiving new request
  # @param [String] data raw data
  def receive_new_request(data)
    begin
      @request.parse(data)
      @response = @api.receive(request, self)
      call_event(:open) if @request.websocket?
    rescue Midori::Exception::NotFound => e
      @response = Midori::Sandbox.capture(e)
    rescue => e
      @response = Midori::Sandbox.capture(e)
      @logger.error e.inspect.red
      @logger.warn e.backtrace.join("\n").yellow
    end
    unless @request.websocket? || @request.eventsource?
      send_data @response
      close_connection_after_writing
    end
  end

  # Logic of receiving WebSocket request
  # @param [StringIO] data raw data
  def websocket_request(data)
    @websocket.decode(data)
    case @websocket.opcode
    when 0x1, 0x2
      call_event(:message, [@websocket.msg])
    when 0x9
      @websocket.pong(@websocket.msg)
      call_event(:ping)
    when 0xA
      call_event(:pong)
    end
  rescue Midori::Exception::FrameEnd => _e
    call_event(:close)
    send_data "\b" # Opcode 0x8
    close_connection_after_writing
  rescue Midori::Exception::PingPongSizeTooLarge => e
    @logger.warn e.inspect.yellow
    call_event(:error) # Too large ping request
    send_data "\b" # Opcode 0x8
    close_connection_after_writing
  rescue => e
    call_event(:error)
    @logger.error e.inspect.red
    @logger.warn e.backtrace.join("\n").yellow
    close_connection_after_writing
  end

  # To call a websocket event if it exist
  # @param [Symbol] event event name
  # @param [Array] args arg list
  def call_event(event, args = [])
    -> { @websocket.instance_exec(*args, &@websocket.events[event]) }.call unless @websocket.events[event].nil?
  end
end
