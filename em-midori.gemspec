require './lib/midori/version'

Gem::Specification.new do |s|
  s.name                     = 'em-midori'
  s.version                  = Midori::VERSION
  s.required_ruby_version    = '>=2.2.6'
  s.date                     = Time.now.strftime('%Y-%m-%d')
  s.summary                  = 'High performance ruby web framework'
  s.description              = 'Midori is a Ruby Web Framework, providing high performance and proper abstraction.'
  s.authors                  = ['HeckPsi Lab']
  s.email                    = 'business@heckpsi.com'
  s.require_paths            = ['lib']
  s.files                    = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|.resources)/}) } \
    - %w(README.md CODE_OF_CONDUCT.md CONTRIBUTING.md Gemfile Rakefile em-midori.gemspec .gitignore .rspec .codeclimate.yml .rubocop.yml .travis.yml logo.png Rakefile Gemfile)
  s.homepage                 = 'https://github.com/heckpsi-lab/em-midori'
  s.metadata                 = { 'issue_tracker' => 'https://github.com/heckpsi-lab/em-midori/issues' }
  s.license                  = 'MIT'
  s.post_install_message     = File.read('.resources/midori_ascii.txt')
  s.add_runtime_dependency     'murasaki', '~> 0.1'
  s.add_runtime_dependency     'mustermann', '~> 1.0'
  s.add_runtime_dependency     'midori_http_parser', '~> 0.6.1'
end
