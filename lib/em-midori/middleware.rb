class Midori::Middleware
  def self.before(request)
    request
  end

  def self.after(_request, response)
    response
  end

  def self.accept
    [String]
  end
end
