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
  count = 0
  %w'lib/em-midori/em-midori.rb lib/em-midori/api.rb lib/em-midori/server.rb'.each do |file|
    Dir.mkdir('./build') unless File.exist?('./build')
    file_to_write = File.new("./build/#{count}.bin", 'w+')
    count += 1
    file_to_write.write(RubyVM::InstructionSequence.compile_file(file).to_binary)
    file_to_write.close
  end
end

task :binary_load do
  Dir[File.dirname(__FILE__) + '/build/*.bin'].each do |file|
    file_to_read = File.new(file, 'r')
    RubyVM::InstructionSequence.load_from_binary(file_to_read.read).eval
    file_to_read.close
  end
  Midori.run(Midori::API, '0.0.0.0', 8080)
end