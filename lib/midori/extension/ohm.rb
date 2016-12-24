safe_require 'ohm', 'gem install ohm'

##
# Midori Extension of ohm through meta programming Redic
class Redic
  # :nodoc:
  def call(*args)
    await(defer{
      @client.connect do
        @client.write(args)
        @client.read
      end
    })
  end
end
