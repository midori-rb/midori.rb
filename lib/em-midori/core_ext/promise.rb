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

class DeferPromise < Promise
  def initialize(deffered)
    super(->(resolve, reject){
      EventMachine.defer(proc {
        begin
          deffered.call
        rescue Exception => e
          e
        end
      },
                         proc { |result| resolve.call(result) })
    })
  end
end

module Kernel
  # Logic dealing of async method
  # @param [Fiber] fiber a fiber to call
  def async_internal(fiber)
    chain = lambda do |result|
      return unless result.is_a?Promise
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

  def defer(&block)
    DeferPromise.new(block)
  end

  # Block the I/O to wait for async method response
  # @param [Promise] promise promise method
  # @example
  #   result = await SQL.query('SELECT * FROM hello')
  def await(promise)
    result = Fiber.yield promise
    raise result if result.is_a?Exception
    result
  end
end
