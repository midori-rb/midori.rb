##
# Ancestor of all middlewares
class Midori::Middleware
  # Init a middleware
  def initialize
  end

  # run before processing a request
  # @param [Midori::Request] request raw request
  # @return [Midori::Request] request to be further processed
  def before(request)
    request
  end

  # run after processing a request
  # @param [Midori::Request] _request raw request
  # @param [Midori::Response] response raw response
  # @return [Midori::Response] response to be further processed
  def after(_request, response)
    response
  end

  # code to be inserted inside CleanRoom
  # @return [nil] nil
  def helper
  end
end
