##
# Meta-programming Proc for Syntactic Sugars
class Proc
  # Convert [ Proc ] to [ Lambda ]
  # @param [ Object ] instance the context
  # @return [ Lambda ] Lambda converted
  # @note Converting [Proc] to [Lambda] may have incorrect behaviours on corner cases.
  # @note See {Ruby Language Issues}[https://bugs.ruby-lang.org/issues/7314] for more details.
  def to_lambda (instance = Object.new)
    instance.define_singleton_method(:_, &self)
    instance.method(:_).to_proc
  end
end
