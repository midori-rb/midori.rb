require './lib/midori/version'

Gem::Specification.new do |s|
  s.name                     = 'midori.rb'
  s.version                  = Midori::VERSION
  s.required_ruby_version    = '>=2.5'
  s.platform                 = Gem::Platform::RUBY
  s.date                     = Time.now.strftime('%Y-%m-%d')
  s.summary                  = 'High performance ruby web framework'
  s.description              = 'Midori is a Ruby Web Framework, providing high performance and proper abstraction.'
  s.authors                  = ['HeckPsi Lab']
  s.email                    = ['business@heckpsi.com']
  s.require_paths            = ['lib']
  s.files                    = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|.resources)/}) } \
    - %w(README.md CODE_OF_CONDUCT.md CONTRIBUTING.md Gemfile Rakefile midori.gemspec .gitignore .rspec .codeclimate.yml .rubocop.yml .travis.yml logo.png Rakefile Gemfile)
  s.extensions               = ['ext/midori/extconf.rb']
  s.homepage                 = 'https://github.com/midori-rb/midori.rb'
  s.metadata                 = { 'issue_tracker' => 'https://github.com/midori-rb/midori.rb/issues' }
  s.license                  = 'MIT'
  s.post_install_message     = File.read('.resources/midori_ascii.txt')
  s.add_runtime_dependency     'async', '~> 1.13'
	s.add_runtime_dependency     'async-io', '~> 1.22'
  s.add_runtime_dependency     'async-http', '~> 0.47.0'
  s.add_runtime_dependency     'async-websocket', '~> 0.13.0'
  s.add_runtime_dependency     'async-container', '~> 0.14.0'
  s.add_runtime_dependency     'mustermann', '~> 1.0'
  s.add_runtime_dependency     'localhost', '~> 1.0'
  s.add_development_dependency 'rake-compiler', '~> 1.0'
end
