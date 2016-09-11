require 'em-midori'

class Hello < Midori::API
  get '/' do
    puts 'Hello World'
  end
  post '/' do
    puts 'Hello World'
  end
  put '/' do
    puts 'Hello World'
  end
  delete '/' do
    puts 'Hello World'
  end
  options '/' do
    puts 'Hello World'
  end
  link '/' do
    puts 'Hello World'
  end
  unlink '/' do
    puts 'Hello World'
  end
end

Hello.new