safe_require 'em-hiredis', 'gem install em-hiredis'

##
# Midori Extension for Redis Driver
class Midori::Redis
  def initialize(*args)
    @connection = EM::Hiredis.connect(*args)
    @connection
  end

  # Call a redis request asynchronously
  # @param [ String ] sys method name
  # @param [ Array ] args args of the method calling
  def method_missing(sys, *args)
    await(Promise.new(->(resolve, _reject) {
      @connection.send(sys, *args).callback do |*ret_args|
        resolve.call(*ret_args)
      end
    }))
  end

  # Return raw pubsub mode
  # @return [ EM::Hiredis::Pubsub ] raw pubsub
  def pubsub
    @connection.pubsub
  end
end
