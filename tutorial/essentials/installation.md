# Installation

## Requirements

Open up a command line prompt. Any commands prefaced with a dollar sign `$` should be run in the command line. Verify that you have a current version of Ruby installed:

```
 $ ruby -v
 ruby 2.4.1p111
```

Generally, midori supports the following ruby interpreters:

- Ruby (MRI) **>= 2.2.6**

 For every version released, it would be tested and **officially ensured** in the following environments:

- Ruby (MRI)
  - 2.2.7
  - 2.3.4
  - 2.4.1

**Note: **

- **For JRuby users, due to some C extensions used in midori, it is still unable to run on the current version of JRuby.**
- **For macOS users, you may meet performance problem due to the issue of [nio4r](https://github.com/socketry/nio4r/issues/125). Very few people would use macOS in production, so this issue may not affect much. We would still be working hard on fixing it, but the issue wouldn't be a high priority one.**

It's hard to say that if it is possible for running on other ruby implementations like Rubinius or RubyMotion, if you're in favor of supporting more ruby implementations, you could open a ticket [here](https://github.com/heckpsi-lab/em-midori/issues), and we are glad to discuss it.

## Install with RubyGems

```
$ gem install em-midori
Successfully installed em-midori-0.3.0
1 gem installed
```

To test whether it has installed properly, run:

```
$ ruby -r "midori" -e "class A < Midori::API;end;Midori::Runner.new(A).start"
```

If you see the following message, then everything now works fine.

```
Midori 0.3.0 is now running on 127.0.0.1:8080
```

## Use Bundler

Example `Gemfile` of basic usage as following:

```ruby
source 'https://rubygems.org'
gem 'bundler', '~> 1.0'
gem 'em-midori', '~> 0.3', require: 'midori'
```

and then running:

```
$ bundle install
```

You could use

```ruby
require 'bundler'
Bundler.require
```

in your entrance ruby file.

To include built-in extensions of midori you could make your `Gemfile` like:

```ruby
source 'https://rubygems.org'
gem 'bundler', '~> 1.0'
gem 'em-midori', '~> 0.3', require: %w'midori midori/extension/sequel'
```

Using bunlder could make dependency management much easier, which helps a lot in scaling project. To learn more about bundler, you could see docs [here](http://bundler.io/docs.html). 

## For Developers in China

You may probably meet problems with rubygems due to unstable overseas internet connection issues in China. The most popular way to solve it is to use mirror provided by [RubyChina](https://gems.ruby-china.org/) or [TUNA](https://mirror.tuna.tsinghua.edu.cn/help/rubygems/) as your gem source. This may have some side effects in development, because there's a few minutes' delay in receiving gem updates.

Alternatively, you could use proxy to connect to the main repository directly to avoid the delay problem. But using proxy is a little too complex in production environment.

Choose the solution better fits your requirements. Mixing the solutions like using proxy in development and using mirror in production is also a good choice.

