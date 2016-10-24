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

  # Define a batch of error handler with given name
  # @param [Array<Symbol>] args names to be defined
  # @return [nil] nil
  # @example
  #   define_error(:foo_error, :bar_error) 
  #   => nil, FooError < StandardError and BarError < StandardError would be defined
  def define_error(*args)
    args.each do |arg|
      class_name = arg.to_s.split('_').collect(&:capitalize).join
      define_class(class_name, StandardError)
    end
    nil
  end
end
