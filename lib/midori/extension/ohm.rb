safe_require 'ohm', 'gem install ohm'
class Redic
  def call(*args)
    await(defer{
      @client.connect do
        @client.write(args)
        @client.read
      end
    })
  end
end
