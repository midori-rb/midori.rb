require 'rake/extensiontask'
require 'rspec/core/rake_task'
require 'yard'
require './lib/midori/version'

task :default => %i(spec)

Rake::ExtensionTask.new('midori')
RSpec::Core::RakeTask.new(:spec)

YARD::Rake::YardocTask.new do |t|
 t.files         = ['lib/**/*.rb']
 t.stats_options = ['--list-undoc', 'markup-provider=kramdown']
end

task :build do
  puts `gem build em-midori.gemspec`
end

task :install do
  puts `gem build em-midori.gemspec`
  puts `gem install ./em-midori-#{Midori::VERSION}.gem`
end

task :count do
  puts 'Library line count:    ' + `find ./lib -name "*.rb"|xargs cat|wc -l`
  puts '  Empty line count:    ' + `find ./lib -name "*.rb"|xargs cat|grep -e "^$"|wc -l`
  puts '  Code line count:     ' + `find ./lib -name "*.rb"|xargs cat|grep -v -e "^$"|grep -v -e "^\s*\#.*$"|wc -l`
  puts '  Comment line count:  ' + `find ./lib -name "*.rb"|xargs cat|grep -v -e "^$"|grep -e "^\s*\#.*$"|wc -l`
  puts 'Spec line count:       ' + `find ./spec -name "*.rb"|xargs cat|wc -l`
  puts 'Total line count:      ' + `find . -name "*.rb"|xargs cat|wc -l`
end
