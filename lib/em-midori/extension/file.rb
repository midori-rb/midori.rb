class Midori::File
  class << self
    def read_promise(*args)
      DeferPromise.new(proc {
        File.read(*args)
      })
    end

    def read(*args)
      await read_promise(*args)
    end

    def write_promise(*args)
      DeferPromise.new(proc {
        File.write(*args)
      })
    end

    def write(*args)
      await write_promise(*args)
    end
  end
end
