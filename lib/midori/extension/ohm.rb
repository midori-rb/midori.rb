safe_require 'ohm', 'gem install ohm'

##
# Midori Extension of ohm through meta programming Redic
class Redic
  # Do Redis call
  def call(*args)
    await(defer{
      @client.connect do
        @client.write(args)
        @client.read
      end
    })
  end
end
