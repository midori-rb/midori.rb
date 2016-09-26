class Midori::Request

  attr_accessor :protocol, :method, :path, :query_string

  # Init an request with StringIO data
  # === Attributes
  # * +data+ [+StringIO+] - Request data
  def initialize(data)
    @raw_data = data
  end

  def parse(stage)
    case stage
      when 0
        line = @raw_data.gets.split
        puts line.join(',')
        @protocol = line[2]
        @method = line[0]
        @query_string = line[1].match(/\?(.*?)$/)
        unless @query_string.nil?
          @query_string = @query_string[1]
        end
        @path = line[1].gsub(/\?(.*?)$/, '')
      when 1
        #TODO: parse header
      else
        raise RuntimeError
    end
  end
end