class Midori::File
  class << self
    def read_promise(*args)
      Promise.new(->(resolve, _reject) {
        EventMachine.defer(proc {
          File.read(*args)
        }, proc {|result|
          resolve.call(result)
        }, proc {|error| 
          raise error
        })
      })
    end

    def read(*args)
        await read_promise(*args)
    end

    def write_promise(*args)
      Promise.new(->(resolve, _reject) {
        EventMachine.defer(proc {
          File.write(*args)
        }, proc {|result|
          resolve.call(result)
        }, proc {|error|
          raise error
        })
      })
    end

    def write(*args)
      await write_promise(*args)
    end
  end
end
