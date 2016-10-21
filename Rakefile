require 'rspec/core/rake_task'
require 'yard'
require './lib/em-midori/version'

task :default => %i(spec)

RSpec::Core::RakeTask.new(:spec)

YARD::Rake::YardocTask.new do |t|
 t.files         = ['lib/**/*.rb']
 t.stats_options = ['--list-undoc', 'markup-provider=redcarpet']
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
