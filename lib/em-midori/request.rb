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

    # Parse request
    line = data.gets.split
    @protocol = line[2]
    @method = line[0]
    @query_string = line[1].match(/\?(.*?)$/)
    unless @query_string.nil?
      @query_string = @query_string[1]
    end
    @path = line[1].gsub(/\?(.*?)$/, '')

    # Parse header
    while (line = data.gets) != "\r\n"
      line = line.split
      @header[line[0][0..-2]] = line[1..-1].join(' ')
    end

    # Deal with WebSocket
    if @header['Upgrade'] == 'websocket' && @header['Connection'] == 'Upgrade'
      @method = 'WEBSOCKET'
    end

    # Parse body
    @body = data.read
  end
end