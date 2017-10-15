##
# Abstract runner class to control instance of Midori Server
# @attr [String] bind the address to bind
# @attr [Integer] port the port to bind
# @attr [Logger] logger midori logger
class Midori::Runner
  attr_reader :bind, :port, :logger

  # Define status of a runner
  # @param [Class] api inherited from [Midori::API]
  # @param [Class] configure inherited from [Midori::Configure]
  def initialize(api, configure = Midori::Configure)
    @logger = configure.logger
    Midori.logger = configure.logger
    @bind = configure.bind
    @port = configure.port
    @api = (api.is_a? Midori::APIEngine) ? api : Midori::APIEngine.new(api, configure.route_type)
    @before = configure.before
  end

  # Get Midori server whether running
  # @return [Boolean] [true] running
  # @return [Boolean] [false] not running
  def running?
    !!@server
  end

  # Start the Midori server
  # @note This is an async method, but no callback
  def start
    return false if running? || EventLoop.running?
    @logger.info "Midori #{Midori::VERSION} is now running on #{bind}:#{port}".blue
    @server = TCPServer.new(@bind, @port)
    EventLoop.register(@server, :r) do |monitor|
      socket = monitor.io.accept_nonblock
      connection = Midori::Connection.new(socket)
      connection.server_initialize(@api, @logger)
    end
    async_fiber(Fiber.new do
      @before.call
    end)
    EventLoop.start
    nil
  end

  # Stop the Midori server
  # @note This is an async method, but no callback
  # @return [Boolean] [true] stop successfully
  # @return [Boolean] [false] nothing to stop
  def stop
    if running?
      @logger.info 'Stopping Midori'.blue
      EventLoop.deregister @server
      @server.close
      @server = nil
      EventLoop.stop
      true
    else
      @logger.error 'Midori Server has NOT been started'.red
      false
    end
  end
end
