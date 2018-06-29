# midori

**This project is still not production-ready. Questions, suggestions and pull requests are highly welcome.**

[![Backers on Open Collective](https://opencollective.com/midorirb/backers/badge.svg)](#backers) [![Sponsors on Open Collective](https://opencollective.com/midorirb/sponsors/badge.svg)](#sponsors)

![Logo and Slogan](https://github.com/midori-rb/midori.rb/raw/master/.resources/slogan.png)

## Description

Midori is a Ruby Web Framework, providing high performance and proper abstraction.

|                            midori                            | [midori-contrib](https://github.com/midori-rb/midori-contrib) |      [murasaki](https://github.com/midori-rb/murasaki)       | [midori_http_parser](https://github.com/midori-rb/http_parser.rb) |
| :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
| ![midori logo](https://github.com/midori-rb/midori.rb/raw/master/.resources/midori_logo.png) | ![midori logo](https://github.com/midori-rb/midori.rb/raw/master/.resources/contrib_logo.png) | ![midori logo](https://github.com/midori-rb/midori.rb/raw/master/.resources/murasaki_logo.png) | ![midori logo](https://github.com/midori-rb/midori.rb/raw/master/.resources/parser_logo.png) |
|                        Web Framework                         |                     Official Extensions                      |                   Modularized Event Engine                   |                         HTTP Parser                          |
| [![Build Status](https://travis-ci.org/midori-rb/midori.rb.svg?branch=master)](https://travis-ci.org/midori-rb/midori.rb) | [![Build Status](https://travis-ci.org/midori-rb/midori-contrib.svg?branch=master)](https://travis-ci.org/midori-rb/midori-contrib) | [![Build Status](https://travis-ci.org/midori-rb/murasaki.svg?branch=master)](https://travis-ci.org/midori-rb/murasaki) | [![Build Status](https://travis-ci.org/midori-rb/murasaki.svg?branch=master)](https://travis-ci.org/midori-rb/murasaki) |
| [![Test Coverage](https://api.codeclimate.com/v1/badges/f976d625994fa33523b3/test_coverage)](https://codeclimate.com/github/midori-rb/midori.rb) | [![Test Coverage](https://api.codeclimate.com/v1/badges/cfb6d9b359dcb7457eec/test_coverage)](https://codeclimate.com/github/midori-rb/midori-contrib) | [![Test Coverage](https://api.codeclimate.com/v1/badges/d0dc1bc4a3e38bd4f2b9/test_coverage)](https://codeclimate.com/github/midori-rb/murasaki) | [![Test Coverage](https://api.codeclimate.com/v1/badges/0035138294cf3a6fdd07/test_coverage)](https://codeclimate.com/github/midori-rb/http_parser.rb/test_coverage) |
| [![Maintainability](https://api.codeclimate.com/v1/badges/f976d625994fa33523b3/maintainability)](https://codeclimate.com/github/midori-rb/midori.rb) | [![Maintainability](https://api.codeclimate.com/v1/badges/cfb6d9b359dcb7457eec/maintainability)](https://codeclimate.com/github/midori-rb/midori-contrib) | [![Maintainability](https://api.codeclimate.com/v1/badges/d0dc1bc4a3e38bd4f2b9/maintainability)](https://codeclimate.com/github/midori-rb/murasaki) | [![Maintainability](https://api.codeclimate.com/v1/badges/0035138294cf3a6fdd07/maintainability)](https://codeclimate.com/github/midori-rb/http_parser.rb/maintainability) |
| [![doc](http://inch-ci.org/github/midori-rb/midori.rb.svg?branch=master)](http://inch-ci.org/github/midori-rb/midori.rb) | [![doc](http://inch-ci.org/github/midori-rb/midori-contrib.svg?branch=master)](http://inch-ci.org/github/midori-rb/midori-contrib) | [![doc](http://inch-ci.org/github/midori-rb/murasaki.svg?branch=master)](http://inch-ci.org/github/midori-rb/murasaki) | [![doc](http://inch-ci.org/github/midori-rb/http_parser.svg?branch=master)](http://inch-ci.org/github/midori-rb/http_parser.rb) |
| [![Gem Version](https://img.shields.io/gem/v/midori.rb.svg?maxAge=43200)](https://rubygems.org/gems/midori.rb) | [![Gem Version](https://img.shields.io/gem/v/midori-contrib.svg?maxAge=43200)](https://rubygems.org/gems/midori-contrib) | [![Gem Version](https://img.shields.io/gem/v/murasaki.svg?maxAge=43200)](https://rubygems.org/gems/murasaki) | [![Gem Version](https://img.shields.io/gem/v/midori_http_parser.svg?maxAge=43200)](https://rubygems.org/gems/midori_http_parser) |
| [![license](https://img.shields.io/github/license/midori-rb/midori.rb.svg?maxAge=2592000)]() | [![license](https://img.shields.io/github/license/midori-rb/midori-contrib.svg?maxAge=2592000)]() | [![license](https://img.shields.io/github/license/midori-rb/murasaki.svg?maxAge=2592000)]() | [![license](https://img.shields.io/github/license/midori-rb/http_parser.rb.svg?maxAge=2592000)]() |

## Requirements

- **Ruby** >= 2.3.7

## Installation

```bash
gem install midori.rb
```

**With Bundler**

```ruby
gem 'midori.rb'
```

```bash
bundle install
```

## FAQ

### Performance

Following benchmark results testing `{msg: "Hello"}` JSON response by visiting `GET /` with a **single-core, 1GB memory, Amazon Web Service Linux instance**.

| framework                          | version | req/s   |
| :--------------------------------- | :------ | :------ |
| Rails (Thin, Ruby 2.5.1)           | 5.0.6   | 490.23  |
| Rails (API Mode, Thin, Ruby 2.5.1) | 5.0.6   | 785.61  |
| Sinatra (Thin, Ruby 2.5.1)         | 2.0.0   | 1196.23 |
| express.js (Node.js 9.3.0)         | 4.16.0  | 5435.98 |
| midori (Ruby 2.5.1)                | 0.6.0   | 5517.66 |

### Name

The name **midori** comes from **midori machi**, which was the place I stay on my first travel to Tokyo.

### Semantic Versioning

Version consists of four numbers:

|                 |     Milestone     |          Major           |    Minor    |  Patch   |
| --------------- | :---------------: | :----------------------: | :---------: | :------: |
| **Example**     |        1.         |            2.            |     1.      |    5     |
| **Explanation** | Milestone version | Incompatible API changes | Add feature | Fix bugs |

**Note: Before version v1.0, there's no minor version API compatible ensuring.**

### Contributing

See [Contributing Guidelines](CONTRIBUTING.md) before you leave any comment.
This project exists thanks to all the people who contribute.
<a href="graphs/contributors"><img src="https://opencollective.com/midorirb/contributors.svg?width=890" /></a>

### Tutorial & Example

There is an unfinished tutorial available [here](https://github.com/midori-rb/midori-tutorial).

There is also an example showing how to use midori with a todo-list web app available [here](https://github.com/midori-rb/midori-todo-example).

## Roadmap

**Development roadmap has been moved [here](https://github.com/midori-rb/midori.rb/wiki/Roadmap).**


**Detailed release notes for published versions can be seen [here](https://github.com/midori-rb/midori.rb/releases).**

## Midori 2 Goals

1. Support HTTP/2
2. Support RPC/ZeroMQ Based Server
3. Add MVC abstraction example with scaffold
4. Improve structure for fitting [AutoFiber](https://bugs.ruby-lang.org/issues/13618)
5. More examples on using midori

## Backers

Thank you to all our backers! 🙏 [[Become a backer](https://opencollective.com/midorirb#backer)]

<a href="https://opencollective.com/midorirb#backers" target="_blank"><img src="https://opencollective.com/midorirb/backers.svg?width=890"></a>


## Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website. [[Become a sponsor](https://opencollective.com/midorirb#sponsor)]

<a href="https://opencollective.com/midorirb/sponsor/0/website" target="_blank"><img src="https://opencollective.com/midorirb/sponsor/0/avatar.svg"></a>
<a href="https://opencollective.com/midorirb/sponsor/1/website" target="_blank"><img src="https://opencollective.com/midorirb/sponsor/1/avatar.svg"></a>
<a href="https://opencollective.com/midorirb/sponsor/2/website" target="_blank"><img src="https://opencollective.com/midorirb/sponsor/2/avatar.svg"></a>
<a href="https://opencollective.com/midorirb/sponsor/3/website" target="_blank"><img src="https://opencollective.com/midorirb/sponsor/3/avatar.svg"></a>
<a href="https://opencollective.com/midorirb/sponsor/4/website" target="_blank"><img src="https://opencollective.com/midorirb/sponsor/4/avatar.svg"></a>
<a href="https://opencollective.com/midorirb/sponsor/5/website" target="_blank"><img src="https://opencollective.com/midorirb/sponsor/5/avatar.svg"></a>
<a href="https://opencollective.com/midorirb/sponsor/6/website" target="_blank"><img src="https://opencollective.com/midorirb/sponsor/6/avatar.svg"></a>
<a href="https://opencollective.com/midorirb/sponsor/7/website" target="_blank"><img src="https://opencollective.com/midorirb/sponsor/7/avatar.svg"></a>
<a href="https://opencollective.com/midorirb/sponsor/8/website" target="_blank"><img src="https://opencollective.com/midorirb/sponsor/8/avatar.svg"></a>
<a href="https://opencollective.com/midorirb/sponsor/9/website" target="_blank"><img src="https://opencollective.com/midorirb/sponsor/9/avatar.svg"></a>


