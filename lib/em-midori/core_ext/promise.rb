##
# Meta-programming String for Syntactic Sugars
# Referenced from {Qiita}[http://qiita.com/south37/items/99a60345b22ef395d424]
class Promise
  # @param [Proc] callback an async method
  def initialize(callback)
    @callback = callback
  end

  # Define what to do after a method callbacks
  # @param [Proc] resolve what on callback
  # @param [Proc] reject what on callback failed
  # @return [nil] nil
  def then(resolve = ->() {}, reject = ->() {})
    @callback.call(resolve, reject)
  end
end

module Kernel
  # Logic dealing of async method
  # @param [Fiber] fiber a fiber to call
  def async_internal(fiber)
    chain = lambda do |result|
      return if result.class != Promise
      result.then(lambda do |val|
        chain.call(fiber.resume(val))
      end)
    end
    chain.call(fiber.resume)
  end

  # Define an async method
  # @param [Symbol] method_name method name
  # @yield async method
  # @example
  #   async :hello do 
  #     puts 'Hello'
  #   end
  def async(method_name)
    define_singleton_method method_name, ->(*args) {
      async_internal(Fiber.new { yield(*args) })
    }
  end

  # Block the I/O to wait for async method response
  # @param [Promise] promise promise method
  # @example
  #   result = await SQL.query('SELECT * FROM hello')
  def await(promise)
    Fiber.yield promise
  end
end
