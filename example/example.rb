require 'em-midori'
require 'em-midori/extension/file'

class Example < Midori::API
  get '/' do
    begin
      Midori::File.read('dajkldas')
    rescue => e
      e
    end
  end
end

Midori::Runner.new(Example).start
