##
# Class for Midori route
# @attr [String] method HTTP method
# @attr [Regexp] path regex to match
# @attr [Proc] function what to do after matched
class Midori::Route
  attr_accessor :method, :path, :function, :middlewares, :body_accept

  # @param [String] method HTTP method
  # @param [Regexp] path regex to match
  # @param [Proc] function what to do after matched
  def initialize(method, path, function)
    @method = method
    @path = path
    @function = function
    @middlewares = []
    @body_accept = [String]
  end
end
