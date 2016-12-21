class Midori::File
  class << self
    def read(*args)
      await(defer{File.read(*args)})
    end

    def write(*args)
      await(defer{File.write(*args)})
    end
  end
end
