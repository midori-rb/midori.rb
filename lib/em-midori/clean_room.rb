class Midori::CleanRoom
  attr_accessor :code, :header, :body, :request
  def initialize(request)
    @status = 200
    @header = Midori::Const::DEFAULT_HEADER.clone
    @body = ''
    @request = request
  end

  def response
    Midori::Response.new(@status, @header, @body)
  end
end
