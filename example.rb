# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path("./lib", __dir__)

require 'evt'
require 'midori'

Fiber.set_scheduler Evt::Scheduler.new

class HelloWorldAPI < Midori::API
  get '/' do
    'Ohayou Midori'
  end
end

Fiber.schedule do
  Midori::Runner.new(HelloWorldAPI).start
end
