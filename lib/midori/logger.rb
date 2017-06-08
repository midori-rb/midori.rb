module Midori
  class << self
    # Return current logger midori is using
    # @return [Logger] the current logger midori is using
    def logger
      @logger = ::Logger.new(STDOUT) if @logger.nil?
      @logger
    end

    # Return midori's logger
    # @param [Logger] logger set midori logger
    def logger=(logger)
      @logger = logger
    end
  end
end
