##
# Meta-programming Kernel for Syntactic Sugars
module Kernel
  # This method is implemented to dynamically generate class with given name and template.
  # Referenced from {Ruby China}[https://ruby-china.org/topics/17382]
  # @param [String] name name of class
  # @param [Class] ancestor class to be inherited
  # @yield inner block to be inserted into class
  # @return [Class] the class defined
  def define_class(name, ancestor = Object)
    Object.const_set(name, Class.new(ancestor))
    Object.const_get(name).class_eval(&Proc.new) if block_given?
    Object.const_get(name)
  end
end

define_class 'MidoriError', StandardError
