safe_require 'em-hiredis', 'gem install em-hiredis'
module EventMachine::Hiredis
  class BaseClient
    def method_missing(sys, *args)
      if @connected
        @connection.send_command(sys, args)
      end
    end
  end
end