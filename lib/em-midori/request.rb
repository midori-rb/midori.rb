class Midori::Request

  attr_accessor :protocol, :method, :path, :query_string,
                :header, :body

  # Init an request with StringIO data
  # === Attributes
  # * +data+ [+StringIO+] - Request data
  def initialize(data)
    @raw_data = data
    @stage = 0
  end

  def parse(stage)
    if @stage != stage
      raise RuntimeError
    end
    case stage
      when 0
        line = @raw_data.gets.split
        @protocol = line[2]
        @method = line[0]
        @query_string = line[1].match(/\?(.*?)$/)
        unless @query_string.nil?
          @query_string = @query_string[1]
        end
        @path = line[1].gsub(/\?(.*?)$/, '')
        @stage += 1
      when 1
        #TODO: parse header
        @stage += 1
      else
        raise RuntimeError
    end
  end
end