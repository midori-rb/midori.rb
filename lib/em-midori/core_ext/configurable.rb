require 'logger'

module Midori
  module Configurable
    # Modified from Sinatra
    # Sets an option to the given value.  If the value is a proc,
    # the proc will be called every time the option is accessed.
    def set(option, value = (not_set = true), ignore_setter = false, &block)
      raise ArgumentError if block and !not_set
      value, not_set = block, false if block

      if not_set
        raise ArgumentError unless option.respond_to?(:each)
        option.each { |k,v| set(k, v) }
        return self
      end

      if respond_to?("#{option}=") and not ignore_setter
        return __send__("#{option}=", value)
      end

      setter = proc { |val| set option, val, true }
      getter = case value
               when Proc
                 value
               when Symbol, Fixnum, FalseClass, TrueClass, NilClass
                 value.inspect
               when Hash
                 setter = proc do |val|
                   val = value.merge val if Hash === val
                   set option, val, true
                 end
               else
                 proc { value }
               end

      define_singleton("#{option}=", setter) if setter
      define_singleton(option, getter) if getter
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
