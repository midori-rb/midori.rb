# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path("./lib", __dir__)

require 'evt'
require 'midori'
require 'midori-contrib/redic'

Fiber.set_scheduler Evt::Scheduler.new
REDIS = Redic.new

class HelloWorldAPI < Midori::API
  get '/' do
    REDIS.call 'GET', 'foo'
  end
end

Fiber.schedule do
  Midori::Runner.new(HelloWorldAPI).start
end
