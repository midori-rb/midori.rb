##
# This class provides methods to be inherited as route definition.
class Midori::API
  class << self
    # Add GET method as a DSL for route definition
    # === Attributes
    # * +path+ [+String+, +Regexp+] - Accepts as part of path in route definition.
    # === Returns
    # nil
    # === Examples
    # String as router
    #   get '/' do
    #      puts 'Hello World'
    #   end
    #
    # Regex as router
    #   get /\/hello\/(.*?)/ do
    #      puts 'Hello World'
    #   end
    def get(path, &block) end

    # Add POST method as a DSL for route definition
    # === Attributes
    # * +path+ [+String+, +Regexp+] - Accepts as part of path in route definition.
    # === Returns
    # nil
    # === Examples
    # String as router
    #   post '/' do
    #      puts 'Hello World'
    #   end
    #
    # Regex as router
    #   post /\/hello\/(.*?)/ do
    #      puts 'Hello World'
    #   end
    def post(path, &block) end

    # Add PUT method as a DSL for route definition
    # === Attributes
    # * +path+ [+String+, +Regexp+] - Accepts as part of path in route definition.
    # === Returns
    # nil
    # === Examples
    # String as router
    #   put '/' do
    #      puts 'Hello World'
    #   end
    #
    # Regex as router
    #   put /\/hello\/(.*?)/ do
    #      puts 'Hello World'
    #   end
    def put(path, &block) end

    # Add DELETE method as a DSL for route definition
    # === Attributes
    # * +path+ [+String+, +Regexp+] - Accepts as part of path in route definition.
    # === Returns
    # nil
    # === Examples
    # String as router
    #   delete '/' do
    #      puts 'Hello World'
    #   end
    #
    # Regex as router
    #   delete /\/hello\/(.*?)/ do
    #      puts 'Hello World'
    #   end
    def delete(path, &block) end

    # Add OPTIONS method as a DSL for route definition
    # === Attributes
    # * +path+ [+String+, +Regexp+] - Accepts as part of path in route definition.
    # === Returns
    # nil
    # === Examples
    # String as router
    #   options '/' do
    #      puts 'Hello World'
    #   end
    #
    # Regex as router
    #   options /\/hello\/(.*?)/ do
    #      puts 'Hello World'
    #   end
    def options(path, &block) end

    # Add LINK method as a DSL for route definition
    # === Attributes
    # * +path+ [+String+, +Regexp+] - Accepts as part of path in route definition.
    # === Returns
    # nil
    # === Examples
    # String as router
    #   link '/' do
    #      puts 'Hello World'
    #   end
    #
    # Regex as router
    #   link /\/hello\/(.*?)/ do
    #      puts 'Hello World'
    #   end
    def link(path, &block) end

    # Add UNLINK method as a DSL for route definition
    # === Attributes
    # * +path+ [+String+, +Regexp+] - Accepts as part of path in route definition.
    # === Returns
    # nil
    # === Examples
    # String as router
    #   unlink '/' do
    #      puts 'Hello World'
    #   end
    #
    # Regex as router
    #   unlink /\/hello\/(.*?)/ do
    #      puts 'Hello World'
    #   end
    def unlink(path, &block) end

    # Add WEBSOCKET method as a DSL for route definition
    # === Attributes
    # * +path+ [+String+, +Regexp+] - Accepts as part of path in route definition.
    # === Returns
    # nil
    # === Examples
    # String as router
    #   unlink '/' do
    #      puts 'Hello World'
    #   end
    #
    # Regex as router
    #   unlink /\/hello\/(.*?)/ do
    #      puts 'Hello World'
    #   end
    def websocket(path, &block) end

    # Add EVENTSOURCE method as a DSL for route definition
    # === Attributes
    # * +path+ [+String+, +Regexp+] - Accepts as part of path in route definition.
    # === Returns
    # nil
    # === Examples
    # String as router
    #   unlink '/' do
    #      puts 'Hello World'
    #   end
    #
    # Regex as router
    #   unlink /\/hello\/(.*?)/ do
    #      puts 'Hello World'
    #   end
    def eventsource(path, &block) end

    def add_route(method, path, block)
      @route = Array.new if @route.nil?
      if path.class == String
        # Convert String to Regexp to provide performance boost (Precompiled Regexp)
        path = convert_route path
      end
      @route << Midori::Route.new(method, path, block)
      nil
    end

    # Match route with given definition
    # === Attributes
    # * +method+ [+String+] - Accepts an HTTP/1.1 method like GET POST PUT ...
    # * +path+ [+Regexp+] - Precompiled route definition.
    # * +request+ [+String+] - HTTP Request String
    # === Returns
    # if not matched returns false
    #
    # else returns an array of parameter string matched
    # === Examples
    #   match('GET', /^\/user\/(.*?)\/order\/(.*?)$/, '/user/foo/order/bar') # => ['foo', 'bar']
    def match(method, path, request)
      request = request.lines.first.split
      if request[0] == method
        result = request[1].match(path)
        return result.to_a[1..-1] if result
        false
      else
        false
      end
    end

    # Convert String path to its Regexp equivalent
    # === Attributes
    # * +path+ [+String+] - String route definition
    # === Returns
    # Regexp equivalent
    # === Examples
    #   convert_route('/user/:id/order/:order_id') # => Regexp
    def convert_route(path)
      path = '^' + path
                       .gsub(/\/(:[_a-z][_a-z0-9]+?)\//, '/([^/]+?)/')
                       .gsub(/\/(:[_a-z][_a-z0-9]+?)$/, '/([^/]+?)$')
      path += '$' if path[-1] != '$'
      Regexp.new path
    end
  end

  private_class_method :add_route

  METHODS = %w'get post put delete options link unlink websocket eventsource' # :nodoc:

  # Magics to fill DSL methods through dynamically class method definition
  METHODS.each do |method|
    define_singleton_method(method) do |*args|
      add_route(method.upcase, args[0], args[1]) # args[0]: path, # args[1]: block
    end
  end

  @status_code = {
      100 => '100 Continue',
      101 => '101 Switching Protocols',
      200 => '200 OK',
      201 => '201 Created',
      202 => '202 Accepted',
      203 => '203 Non-Authoritative Information',
      204 => '204 No Content',
      205 => '205 Reset Content',
      206 => '206 Partial Content',
      300 => '300 Multiple Choices',
      301 => '301 Moved Permanently',
      304 => '304 Not Modified',
      305 => '305 Use Proxy',
      307 => '307 Temporary Redirect',
      400 => '400 Bad Request',
      401 => '401 Unauthorized',
      402 => '402 Payment Required',
      403 => '403 Forbidden',
      404 => '404 Not Found',
      405 => '405 Method Not Allowed',
      406 => '406 Not Acceptable',
      407 => '407 Proxy Authentication Required',
      408 => '408 Request Time-out',
      409 => '409 Conflict',
      410 => '410 Gone',
      411 => '411 Length Required',
      412 => '412 Precondition Failed',
      413 => '413 Request Entity Too Large',
      414 => '414 Request-URI Too Large',
      415 => '415 Unsupported Media Type',
      416 => '416 Requested range not satisfiable',
      417 => '417 Expectation Failed',
      500 => '500 Internal Server Error',
      501 => '501 Not Implemented',
      502 => '502 Bad Gateway',
      503 => '503 Service Unavailable',
      504 => '504 Gateway Time-out',
      505 => '505 HTTP Version not supported'
  }
  @status_code.default= '500 Internal Server Error'
  @status_code.freeze

end

class Midori::Route
  attr_accessor :method, :path, :function

  def initialize(method, path, function)
    @method = method
    @path = path
    @function = function
  end
end