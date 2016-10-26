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
      EM.stop
      true
    else
      @logger.error 'Midori Server has NOT been started'.red
      false
    end
  end
end
