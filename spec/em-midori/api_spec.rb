require 'em-midori'

class Hello < Midori::API
  post '/' do
    puts 'Hello World'
  end
end

Hello.new