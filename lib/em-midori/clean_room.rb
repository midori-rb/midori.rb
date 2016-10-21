class Midori::CleanRoom
  attr_accessor :code, :header, :body, :request
  def initialize(request, middleware = [], body_accept = [String])
    @status = 200
    @header = Midori::Const::DEFAULT_HEADER.clone
    @body = ''
    @request = request
    @middleware = middleware
    @body_accept = body_accept
  end

  def raw_response
    Midori::Response.new(@status, @header, @body)
  end

  def use(middleware, *args)
    middleware = middleware.new(*args)
    middleware.helper
    @middleware = [] if @middleware.nil?
    @middleware << middleware
    @body_accept.replace middleware.body_accept
    @request = middleware.before(request)
  end
end
