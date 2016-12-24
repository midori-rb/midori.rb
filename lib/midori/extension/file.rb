##
# Midori Extension of File reading and writing
class Midori::File
  class << self
    # Same APIs as File.read
    # @param [ Array ] args args of File.read
    def read(*args)
      await(defer{File.read(*args)})
    end

    # Same APIs as File.write
    # @param [ Array ] args args of File.write
    def write(*args)
      await(defer{File.write(*args)})
    end
  end
end
