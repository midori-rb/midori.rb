require 'em-midori'

Thread.new { Midori.run(Midori::API, '0.0.0.0', 8080) }
sleep(1)