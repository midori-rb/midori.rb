# Referenced from {Qiita}[http://qiita.com/south37/items/99a60345b22ef395d424]
class Promise
  def initialize(callback)
    @callback = callback
  end

  def then(resolve = ->() {}, reject = ->() {})
    @callback.call(resolve, reject)
  end
end

def async_internal(fiber)
  chain = ->(result) {
    return if result.class != Promise
    result.then(->(val) {
        chain.call(fiber.resume(val))
    })
  }
  chain.call(fiber.resume)
end

def async(method_name, &block)
  define_singleton_method method_name, ->(*args) {
    async_internal(Fiber.new {block.call(*args)})
  }
end

def await(promise)
  Fiber.yield promise
end
