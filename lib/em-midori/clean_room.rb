class CleanRoom
  attr_accessor :code, :header, :body
  def initialize
    @code = 200
    @header = {}
    @body = ''
  end

  def response
    Midori::Response.new(@code, @header, @body)
  end
end