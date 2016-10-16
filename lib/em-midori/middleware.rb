class Midori::Middleware
  def self.before(request)
    request
  end

  def self.after(_request, response)
    response
  end
end
