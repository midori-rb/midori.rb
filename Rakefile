require 'rspec/core/rake_task'
require 'yard'
require './lib/em-midori/version'

task :default => %i(spec)

RSpec::Core::RakeTask.new(:spec)

YARD::Rake::YardocTask.new do |t|
 t.files         = ['lib/**/*.rb']
 t.stats_options = ['--list-undoc', 'markup-provider=kramdown']
end

task :build do
  puts `gem build em-midori.gemspec`
end

task :pre_compile do
  RubyVM::InstructionSequence.compile_option = {
    inline_const_cache: true,
    instructions_unification: true,
    operands_unification: true,
    peephole_optimization: true,
    specialized_instruction: true,
    stack_caching: true,
    tailcall_optimization: true,
    trace_instruction: false,
  }

  Dir.mkdir('bin') unless File.exist?('bin')
  Dir.mkdir('bin/lib') unless File.exist?('bin/lib')
  Dir.mkdir('bin/lib/em-midori') unless File.exist?('bin/lib/em-midori')
  Dir.mkdir('bin/lib/em-midori/core_ext') unless File.exist?('bin/lib/em-midori/core_ext')
  Dir.glob('lib/**/*.rb') do |location|
    # Binary file generation
    f = File.new("bin/#{location}c", 'w+')
    f.write RubyVM::InstructionSequence.compile_file(location).to_binary
    f.close
    
    # Helper file
    f = File.new("bin/#{location}", 'w+')
    f.write <<-RUBY
f = File.new('#{location}c', 'r')
RubyVM::InstructionSequence.load_from_binary(f.read).eval
f.close
RUBY

    f.close
  end
end

task :install do
  puts `gem build em-midori.gemspec`
  puts `gem install ./em-midori-#{Midori::VERSION}.gem`
end

task :count do
  puts 'Library line count: ' + `find ./lib -name "*.rb"|xargs cat|wc -l` 
  puts 'Spec line count:    ' + `find ./spec -name "*.rb"|xargs cat|wc -l`
  puts 'Example line count: ' + `find ./example -name "*.rb"|xargs cat|wc -l`
  puts 'Total line count:   ' + `find . -name "*.rb"|xargs cat|wc -l`
end
