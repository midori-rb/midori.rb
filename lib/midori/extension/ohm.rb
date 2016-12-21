safe_require 'redic', 'gem install redic'
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
safe_require 'ohm', 'gem install ohm'
