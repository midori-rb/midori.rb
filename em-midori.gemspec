require './lib/em-midori/version'

Gem::Specification.new do |s|
  s.name                     = 'em-midori'
  s.version                  = Midori::VERSION
  s.required_ruby_version    = '>=2.0.0'
  s.date                     = Time.now.strftime('%Y-%m-%d')
  s.summary                  = 'An EventMachine Based Web Framework on Ruby'
  s.description              = 'An EventMachine Based Web Framework on Ruby'
  s.authors                  = ['HeckPsi Lab']
  s.email                    = 'business@heckpsi.com'
  s.require_paths            = ['lib']
  s.files                    = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|example)/}) } \
    - %w(README.md Gemfile Rakefile em-midori.gemspec)
  s.homepage                 = 'https://github.com/heckpsi-lab/em-midori'
  s.license                  = 'MIT'
  s.add_runtime_dependency     'eventmachine', '~> 1.2', '> 1.2.0.0'
  s.add_development_dependency 'bundler', '~> 1.0'
  s.add_development_dependency 'rake', '~> 11.2'
  s.add_development_dependency 'rspec', '~> 3.0'
end