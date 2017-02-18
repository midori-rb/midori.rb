require_relative './midori.rb'

class API < Midori::API
  get '/' do
    'Hello World'
  end
end

$runner = Midori::Runner.new(API)
$runner.stop
Thread.new { $runner.start; exit }
sleep 1000