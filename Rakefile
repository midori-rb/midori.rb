require 'rspec/core/rake_task'
require 'rdoc/task'

task :default => %i(spec)

RSpec::Core::RakeTask.new(:spec)

RDoc::Task.new do |rdoc|
  rdoc.main = 'README.rdoc'
  rdoc.rdoc_dir = 'rdoc'
  rdoc.rdoc_files.include('lib/*')
  rdoc.options << '--all'
end

task :run do
  require './lib/em-midori'

  include Midori
  class Example < API
    get '/' do
      'Hello World'
    end

    get '/user/:id' do |id|
      id
    end

    get '/error' do
      @code, @body = 500, 'Internal Error'
    end
  end

  Midori.run(Example, '127.0.0.1', 8080)
end