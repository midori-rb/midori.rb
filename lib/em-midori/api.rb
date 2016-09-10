class Midori::API
  # def self.get(route)
  #   yield
  # end
  #
  def self.post(route)
    yield
  end
  #
  # def self.put(route)
  #   yield
  # end
  #
  # def self.delete(route)
  #   yield
  # end
  #
  # def self.options(route)
  #   yield
  # end
  #
  # def self.link(route)
  #   yield
  # end
  #
  # def self.unlink(route)
  #   yield
  # end
end