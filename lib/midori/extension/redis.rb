safe_require 'em-hiredis', 'gem install em-hiredis'

##
# Midori Extension for Redis Driver
class Midori::Redis
  def initialize(*args)
    @connection = EM::Hiredis.connect(*args)
    @connection
  end

  # Call a redis request asynchronously
  def method_missing(sys, *args)
    await(Promise.new(->(resolve, _reject) {
      @connection.send(sys, *args).callback do |*ret_args|
        resolve.call(*ret_args)
      end
    }))
  end

  # Return raw pubsub mode
  def pubsub
    @connection.pubsub
  end
end
