class Midori::Sandbox
  class << self
    def class_initialize
      @handlers = Hash.new
    end

    def add_rule(class_name, block)
      error = define_class(class_name.to_s.split('_').collect(&:capitalize).join, MidoriError)
      @handlers[error] = block
    end

    def capture(error, clean_room)
      @handlers[error.class].call(clean_room) unless @handlers[error.class].nil?
    end

    def run(clean_room, function, *args)
      begin
        function.to_lambda(clean_room).call(*args)
      rescue MidoriError => e
        capture(e, clean_room)
      end
    end
  end
  class_initialize
end
