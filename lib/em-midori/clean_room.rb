class CleanRoom
  attr_accessor :code, :header, :body, :request
  def initialize(request)
    @status = 200
    @header = {}
    @body = ''
    @request = request
  end

  def response
    Midori::Response.new(@status, @header, @body)
  end
end
