class Midori::Sandbox
  class << self
    def class_initialize
      @handlers = Hash.new
      @handlers[Midori::Exception::InternalError] = proc {|_e| Midori::Response.new(500, {}, 'Internal Server Error')}
      @handlers[Midori::Exception::NotFound] = proc {|_e| Midori::Response.new(404, {}, '404 Not Found')}
    end

    def add_rule(class_name, block)
      @handlers[class_name] = block
    end

    def capture(error)
      if @handlers[error.class].nil?
        @handlers[Midori::Exception::InternalError].call(error)
      else
        @handlers[error.class].call(error) 
      end
    end

    def run(clean_room, function, *args)
      begin
        function.to_lambda(clean_room).call(*args)
      rescue StandardError => e
        capture(e)
      end
    end
  end
  class_initialize
end
