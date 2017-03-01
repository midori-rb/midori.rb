##
# Meta-programming String for Syntactic Sugars
# Referenced from {Qiita}[http://qiita.com/south37/items/99a60345b22ef395d424]
class Promise
  # Init a Promise
  # @param [Proc] callback an async method
  def initialize(&callback)
    @callback = callback
  end

  # Define what to do after a method callbacks
  # @param [Proc] resolve what on callback
  # @return [nil] nil
  def then(&resolve)
    @callback.call(resolve)
  end
end

module Kernel
  def async_fiber(fiber)
    chain = proc do |result|
      next unless result.is_a? Promise
      result.then do |val|
        chain.call(fiber.resume(val))
      end
    end
    chain.call(fiber.resume)
  end

  # Define an async method
  # @param [Symbol] method method name
  # @yield async method
  # @example
  #   async :hello do 
  #     puts 'Hello'
  #   end
  def async(method)
    define_singleton_method method do |*args|
      async_fiber(Fiber.new {yield(*args)})
    end
  end

  # Block the I/O to wait for async method response
  # @param [Promise] promise promise method
  # @example
  #   result = await SQL.query('SELECT * FROM hello')
  def await(promise)
    result = Fiber.yield promise
    if result.is_a? PromiseException
      raise result.payload
    end
    result
  end
end

class PromiseException < Exception
  attr_reader :payload
  def initialize(payload)
    @payload = payload
  end
end