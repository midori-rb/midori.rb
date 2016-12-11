require './lib/em-midori/version'

Gem::Specification.new do |s|
  s.name                     = 'em-midori'
  s.version                  = Midori::VERSION
  s.required_ruby_version    = '>=2.0.0'
  s.date                     = Time.now.strftime('%Y-%m-%d')
  s.summary                  = 'An EventMachine Based Web Framework on Ruby'
  s.description              = 'EM Midori is an EventMachine-based Web Framework written in pure Ruby, providing high performance and proper abstraction.'
  s.authors                  = ['HeckPsi Lab']
  s.email                    = 'business@heckpsi.com'
  s.require_paths            = ['lib']
  s.files                    = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|.resources)/}) } \
    - %w(README.md CONTRIBUTOR_COVENANT_CODE_OF_CONDUCT.md Gemfile Rakefile em-midori.gemspec .gitignore .rspec .codeclimate.yml .rubocop.yml .travis.yml logo.png Rakefile Gemfile)
  s.homepage                 = 'https://github.com/heckpsi-lab/em-midori'
  s.license                  = 'MIT'
  s.add_runtime_dependency     'eventmachine', '~> 1.2'
  s.add_runtime_dependency     'http_parser.rb', '~> 0.6'
  s.add_runtime_dependency     'mustermann', '~> 0.4'
end
