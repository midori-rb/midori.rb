##
# Abstract runner class to control instance of Midori Server
# @attr [String] bind the address to bind
# @attr [Integer] port the port to bind
# @attr [Logger] logger midori logger
class Midori::Runner
  attr_reader :bind, :port, :logger

  # Define status of a runner
  # @param [Class] api inherited from [Midori::API]
  def initialize(api)
    configure = Midori::Configure
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
    return false if running?
    @logger.info "Midori #{Midori::VERSION} is now running on #{bind}:#{port}".blue
    init_socket
    Fiber.schedule do
      @logger.info 'Midori is booting...'.blue
      @before.call
      @logger.info 'Midori is serving...'.blue
      Fiber.schedule do
        loop do
          socket = @server.accept
          connection = Midori::Connection.new(socket)
          connection.server_initialize(@api, @logger)
          connection.listen
        end
      end
    end
    nil
  end

  private def init_socket
    @server = Socket.new Socket::AF_INET, Socket::SOCK_STREAM
    @server.reuse_port if Midori::Configure.socket_reuse_port
    @server.bind Addrinfo.tcp @bind, @port
    @server.listen Socket::SOMAXCONN
    if Midori::Configure.tcp_fast_open
      tfo = @server.tcp_fast_open
      @logger.warn 'Failed to use TCP Fast Open feature on your OS'.yellow unless tfo
    end
  end

  # Stop the Midori server
  # @note This is an async method, but no callback
  # @return [Boolean] [true] stop successfully
  # @return [Boolean] [false] nothing to stop
  def stop
    if running?
      @logger.info 'Stopping Midori'.blue
      @server.close
      @server = nil
      true
    else
      @logger.error 'Midori Server has NOT been started'.red
      false
    end
  end
end
