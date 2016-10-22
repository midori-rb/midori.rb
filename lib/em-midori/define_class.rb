##
# Meta-programming Kernel for Syntactic Sugars
module Kernel
  # This method is implemented to dynamically generate class with given name and template.
  # Referenced from {Ruby China}[https://ruby-china.org/topics/17382]
  def define_class(name, ancestor = Object)
    Object.const_set(name, Class.new(ancestor))
    Object.const_get(name).class_eval(&Proc.new) if block_given?
    Object.const_get(name)
  end

  def define_error(*args)
    args.each do |arg|
      class_name = arg.to_s.split('_').collect(&:capitalize).join
      define_class(class_name, StandardError)
    end
  end
end
