class CleanRoom
  attr_accessor :code, :header, :body
  def initialize
    @status = 200
    @header = {}
    @body = ''
  end

  def response
    Midori::Response.new(@status, @header, @body)
  end
end