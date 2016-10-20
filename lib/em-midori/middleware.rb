class Midori::Middleware
  def initialize
  end

  def before(request)
    request
  end

  def after(_request, response)
    response
  end

  def body_accept
    [String]
  end
end
