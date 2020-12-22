##
# Logic to EventMachine TCP Server, running inside +Midori::Connection+
module Midori::Server
  # @!attribute request
  #   @return [Midori::Request] raw request
  # @!attribute api
  #   @return [Class] inherited from Midori::API
  # @!attribute websocket
  #   @return [Midori::WebSocket] defined websocket instance
  # @!attribute eventsource
  #   @return [Midori::EventSource] defined eventsource instance
  attr_accessor :request, :api, :websocket, :eventsource

  # Define server behaviour
  # @param [Class] api inherited from Midori::API
  # @param [Logger] logger global logger
  def server_initialize(api, logger)
    @api = api
    @logger = logger

    @request = Midori::Request.new
    @websocket = Midori::WebSocket.new(self)
    @eventsource = Midori::EventSource.new(self)

    # Add keep-alive parameters
    @keep_alive_timer = nil
    @keep_alive_count = 1
  end

  # Logic of receiving data
  # @param [Scoket] the socket able to read
  def receive_data(socket)
    begin
      @request.ip, @request.port = @peer_addr
      data = socket.gets
      if @request.parsed? && @request.body_parsed?
        websocket_request(StringIO.new(data))
      else
        @request.parse(data)
        receive_new_request if @request.parsed? && @request.body_parsed?
      end
    rescue EOFError, Errno::ENOTCONN => _e
      close_connection
      # Ignore client's disconnection
    rescue => e
      # :nocov:
      # Leave for corner cases
      close_connection
      @logger.warn "#{@request.ip} - - #{e.class} #{e.backtrace.join("\n")}".yellow
      # :nocov:
    end
  end

  # Logic of receiving new request
  def receive_new_request
    begin
      start_time = Time.now
      @response = @api.receive(request, self)
      now_time = Time.now
      @logger.info "#{@request.ip} - - \"#{@request.method} #{@request.path} HTTP/#{@request.protocol}\" #{@response.status} #{sprintf("%.6f", now_time.to_f - start_time.to_f)}".green
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
      proceed_keep_alive
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

  private def proceed_keep_alive
    # Detect if it should close connection
    if !Midori::Configure.keep_alive || (@keep_alive_count >= Midori::Configure.keep_alive_requests)
      close_connection_after_writing
      return
    end
    # Add timeout for keep-alive
    @keep_alive_count += 1
    Fiber.schedule do
      sleep Midori::Configure.keep_alive_timeout
      close_connection
    end
    # Reset request
    @request.reset!
  end
end
