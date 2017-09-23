# Extensions

Extensions are rubygems that could combine other gems with midori through meta-programming.
There's a set of officially supported midori extensions called `midori-contrib`.
This contains gems commonly used like Database ORM, Redis Driver, Redis ORM, HTTP Driver, etc.

To include it inside your project, be sure to get the original gem installed without require it.
Then include specific parts of `midori-contrib` to make it work.

For example:

`Gemfile`

```ruby
source 'https://rubygems.org'

gem 'bundler', '~> 1.0'
gem 'rake', '~> 12.0'

gem 'hiredis', '~> 0.6.0', require: false
gem 'ohm', '~> 3.0'
gem 'sequel', '~> 5.0', require: false
gem 'mysql2', '~> 0.4', require: false

gem 'em-midori', '~> 0.4.3', require: 'midori'
gem 'midori-contrib', '~> 0.1.0', require: %w(
    midori-contrib
    midori-contrib/sequel/mysql2
    midori-contrib/redic
  )
```
