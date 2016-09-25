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

    def receive(request)
      @route.each do |route|
        matched = match(route.method, route.path, request)
        if matched
          # puts "route matched: #{route.method} #{route.path}"
          clean_room = CleanRoom.new
          result = clean_room.instance_exec(*matched, &route.function)
          clean_room.body = result if result.class == String
          return clean_room.response
        end
      end
      # 404
      Midori::Response.new(404, {}, '404 Not Found')
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
    define_singleton_method(method) do |*args, &block|
      add_route(method.upcase, args[0], block) #args[0]: path
    end
  end

end

class Midori::Route
  attr_accessor :method, :path, :function
  def initialize(method, path, function)
    @method = method
    @path = path
    @function = function
  end
end