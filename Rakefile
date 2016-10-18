require 'rspec/core/rake_task'
require 'rdoc/task'
require './lib/em-midori/version'

task :default => %i(spec)

RSpec::Core::RakeTask.new(:spec)

RDoc::Task.new do |rdoc|
  rdoc.main = 'README.rdoc'
  rdoc.rdoc_dir = 'rdoc'
  rdoc.rdoc_files.include('lib/*')
  rdoc.options << '--all'
end

task :build do
  puts `gem build em-midori.gemspec`
end

task :install do
  puts `gem build em-midori.gemspec`
  puts `gem install ./em-midori-#{Midori::VERSION}.gem`
end

task :count do
  puts 'Library line count: ' + `find ./lib -name "*.rb"|xargs cat|wc -l` 
  puts 'Spec line count:    ' + `find ./spec -name "*.rb"|xargs cat|wc -l`
  puts 'Example line count: ' + `find ./example -name "*.rb"|xargs cat|wc -l`
  puts 'Total line count: ' + `find . -name "*.rb"|xargs cat|wc -l`
end
