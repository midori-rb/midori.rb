require 'stringio'

class Midori::Request
  attr_accessor :ip, :port,
                :protocol, :method, :path, :query_string,
                :header, :body

  # Init an request with StringIO data
  # === Attributes
  # * +data+ [+StringIO+] - Request data
  def initialize(data)
    @header = Hash.new

    line = data.gets.split
    @protocol = line[2]
    @method = line[0]
    @query_string = line[1].match(/\?(.*?)$/)
    unless @query_string.nil?
      @query_string = @query_string[1]
    end
    @path = line[1].gsub(/\?(.*?)$/, '')

    loop do
      line = data.gets
      if line == "\r\n"
        break
      end
      line = line.split
      @header[line[0][0..-2]] = line[1..-1].join(' ')
    end

    if @header['Upgrade'] == 'websocket' && @header['Connection'] == 'Upgrade'
      @method = 'WEBSOCKET'
    end

    @body = data.read
  end
end