module Kernel #:nodoc:
  # This method is implemented to dynamically generate class with given name and template.
  # Referenced from {Ruby China}[https://ruby-china.org/topics/17382]
  def define_class(name, ancestor = Object)
    Object.const_set(name, Class.new(ancestor))
    Object.const_get(name).class_eval(&Proc.new) if block_given?
    Object.const_get(name)
  end

  def define_error(*args)
    args.each do |arg|
      class_name = arg.to_s.split('_').map { |word| word[0] = word[0].upcase; word }.join
      define_class(class_name, StandardError)
    end
  end
end
