safe_require 'em-hiredis', 'gem install em-hiredis'
class Midori::Redis
  def initialize(*args)
    @connection = EM::Hiredis.connect(*args)
    @connection
  end

  def method_missing(sys, *args)
    await(Promise.new(->(resolve, _reject) {
      @connection.send(sys, *args).callback do |*ret_args|
        resolve.call(*ret_args)
      end
    }))
  end

  def pubsub
    @connection.pubsub
  end
end
