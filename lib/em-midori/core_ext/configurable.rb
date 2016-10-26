module Midori
  module Configurable
    # Modified from Sinatra
    # Sets an option to the given value.  If the value is a proc,
    # the proc will be called every time the option is accessed.
    def set(option, value = (not_set = true), read_only = false)
      raise ArgumentError if not_set

      setter = proc { |val| set option, val }
      getter = proc { value }

      define_singleton("#{option}=", setter) unless read_only
      define_singleton(option, getter)
      define_singleton("#{option}?", "!!#{option}") unless method_defined? "#{option}?"

      self
    end

    private

    # Dynamically defines a method on settings.
    def define_singleton(name, content = Proc.new)
      singleton_class.class_eval do
        undef_method(name) if method_defined? name
        String === content ? class_eval("def #{name}() #{content}; end") : define_method(name, &content)
      end
    end
  end
end
