class Midori::File
  class << self
    def read_promise(path)
      Promise.new(->(resolve, _reject) {
        EventMachine.defer(proc {
          File.read(path)
        }, proc {|result|
          resolve.call(result)
        }, proc {|error| 
          raise error
        })
      })
    end

    def read(path)
        await read_promise(path)
    end
  end
end
