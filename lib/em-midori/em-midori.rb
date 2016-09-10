require 'eventmachine'

module Midori
  def self.run(api=(Midori::API), ip=nil, port=nil)
    ip ||= '127.0.0.1'
    port ||= 8081
    EventMachine.run {
      route = api.new
      puts "Midori Server Running on #{ip} at #{port}"
      EventMachine.start_server ip, port, Midori::Server
    }
  end
end