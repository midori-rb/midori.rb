##
# The main module of Midori
module Midori
  @logger = ::Logger.new(STDOUT)
  # Start Midori Server instance
  # @note This is an async method, but no callback
  # @param [Class] api Inherit from +Midori::API+
  # @param [String] ip The ip address to bind
  # @param [Fixnum] port Port number
  # @param [Logger] logger Ruby logger
  # @return [nil] nil
  def self.run(api = Midori::API, ip = '127.0.0.1', port = 8081, logger = ::Logger.new(STDOUT))
    @logger = logger
    EventMachine.set_simultaneous_accept_count(40) unless RUBY_PLATFORM == "java"
    EventMachine.run do
      @logger.info "Midori #{Midori::VERSION} is now running on #{ip}:#{port}".blue
      @midori_server = EventMachine.start_server ip, port, Midori::Server, api, logger
    end
    nil
  end

  # Stop Midori Server instance
  # @note This is an async method, but no callback
  # @return [Boolean] [true] stop successfully
  # @return [Boolean] [false] nothing to stop
  def self.stop
    if @midori_server.nil?
      @logger.error 'Midori Server has NOT been started'.red
      return false
    else
      EventMachine.stop_server(@midori_server)
      @midori_server = nil
      @logger.info 'Goodbye Midori'.blue
      return true
    end
  end
end
