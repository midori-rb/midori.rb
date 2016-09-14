module Kernel #:nodoc:
  # This method is implemented to dynamically generate class with given name and template.
  # Referenced from {Ruby China}[https://ruby-china.org/topics/17382]
  def define_class(name, ancestor = Object)
    Object.const_set(name, Class.new(ancestor))
    Object.const_get(name).class_eval(&Proc.new) if block_given?
    Object.const_get(name)
  end
end