class Midori::Route
  attr_accessor :method, :path, :function
  def initialize(method, path, function)
    @method = method
    @path = path
    @function = function
  end
end
