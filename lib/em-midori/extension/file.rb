require 'file'

class Midori::File
  class << self
    def read_promise(path)
      Promise.new(->(resolve, reject) {
        EventMachine.defer(proc {
          File.open(path, 'r') do |file|
            resolve.call(file.read)
          end
        }, resolve, reject)
      })
    end

    def read(path)
        await(read_promise(path))
    end
  end
end
