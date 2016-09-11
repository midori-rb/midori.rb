class Midori::API

  def self.get(route)
    @route = Array.new if @route.nil?
    @route << Midori::Route.new('GET', route, lambda {yield})
  end

  def self.post(route)
    @route = Array.new if @route.nil?
    @route << Midori::Route.new('POST', route, lambda {yield})
  end

  def self.put(route)
    @route = Array.new if @route.nil?
    @route << Midori::Route.new('PUT', route, lambda {yield})
  end

  def self.delete(route)
    @route = Array.new if @route.nil?
    @route << Midori::Route.new('DELETE', route, lambda {yield})
  end

  def self.options(route)
    @route = Array.new if @route.nil?
    @route << Midori::Route.new('OPTIONS', route, lambda {yield})
  end

  def self.link(route)
    @route = Array.new if @route.nil?
    @route << Midori::Route.new('LINK', route, lambda {yield})
  end

  def self.unlink(route)
    @route = Array.new if @route.nil?
    @route << Midori::Route.new('UNLINK', route, lambda {yield})
  end
  #
  # def self.match(method, route)
  #
  # end
end

class Midori::Route
  attr_accessor :method, :route, :function

  def initialize(method, route, function)
    @method = method
    @route = route
    @function = function
  end
end