##
# This class is used to be sandbox of requests processing.
# @attr [Fixnum] code HTTP response code
# @attr [Hash] header HTTP response header
# @attr [Object] body HTTP response body. String could is accepted by default, but could leave for further process with +Midori::Midlleware+
# @attr [Midori::Request] request HTTP request
class Midori::CleanRoom
  attr_accessor :code, :header, :body, :request
  # @param [Midori::Request] request HTTP request
  # @param [Array<Midori::Middleware>] middleware middlewares to run
  # @param [Array<Class>] body_accept what class for body could last middleware accept by default
  def initialize(request, middleware = [], body_accept = [String])
    @status = 200
    @header = Midori::Const::DEFAULT_HEADER.clone
    @body = ''
    @request = request
    @middleware = middleware
    @body_accept = body_accept
  end

  # Genenrate response from variables inside +Midori::CleanRoom+
  # @return [Midori::Response] midori response
  def raw_response
    Midori::Response.new(@status, @header, @body)
  end

  # Add a middleware to a specific route
  # @param [Class] middleware inherited form +Midori::Middleware+ class
  # @param [Array<Object>] args for middleware initialize
  # @return [nil] nil
  def use(middleware, *args)
    middleware = middleware.new(*args)
    middleware.helper
    @middleware = [] if @middleware.nil?
    @middleware << middleware
    @body_accept.replace middleware.body_accept
    @request = middleware.before(request)
    nil
  end
end
