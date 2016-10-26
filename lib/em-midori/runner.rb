class Midori::Runner
  attr_reader :bind, :port

  def initialize(api, configure = Midori::Configure)
    @logger = configure.logger
    @bind = configure.bind
    @port = configure.port

    @api = api
  end

  # Get Midori server whether running
  # @return [Boolean] [true] running
  # @return [Boolean] [false] not running
  def running?
    !!@server_signature
  end

  # Start the Midori server
  # @note This is an async method, but no callback
  def start
    return if running?

    EventMachine.set_simultaneous_accept_count(40) unless RUBY_PLATFORM == 'java'
    EventMachine.run do
      @logger.info "Midori #{Midori::VERSION} is now running on #{bind}:#{port}".blue
      @server_signature = EventMachine.start_server bind, port, Midori::Server, @api, @logger
    end
    wait_for_server(true)
    nil
  end

  # Stop the Midori server
  # @note This is an async method, but no callback
  # @return [Boolean] [true] stop successfully
  # @return [Boolean] [false] nothing to stop
  def stop
    if running?
      @logger.info 'Goodbye Midori'.blue
      EventMachine.stop_server(@server_signature)
      @server_signature = nil
      wait_for_server(false)
      EM.stop
      true
    else
      @logger.error 'Midori Server has NOT been started'.red
      false
    end
  end

  def is_port_in_use?(ip, port)
    begin
      TCPSocket.new(ip, port)
    rescue Errno::ECONNREFUSED
      return false
    end
    true
  end

  def wait_for_server(status)
    count = 0
    loop {
      res = is_port_in_use?(@bind, @port)
      break unless status^res
      count += 1
      raise 'OperationTimeout' if count > 10000
      sleep 0.1
    }
  end
end
