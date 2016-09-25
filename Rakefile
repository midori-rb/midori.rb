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

task :build do
  puts `gem build em-midori.gemspec`
end