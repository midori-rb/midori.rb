# midori

**This project is still not production-ready. Questions, suggestions and pull requests are highly welcome.**

**🎉 Celebrate 10K downloads to midori.**

![Logo and Slogan](https://github.com/heckpsi-lab/em-midori/raw/master/.resources/slogan.png)

## Description

Midori is a Ruby Web Framework, providing high performance and proper abstraction.

|                  midori                  | [midori-contrib](https://github.com/heckpsi-lab/midori-contrib) | [murasaki](https://github.com/heckpsi-lab/murasaki) |
| :--------------------------------------: | :--------------------------------------: | :--------------------------------------: |
| ![midori logo](https://github.com/heckpsi-lab/em-midori/raw/master/.resources/midori_logo.png) | ![midori logo](https://github.com/heckpsi-lab/em-midori/raw/master/.resources/contrib_logo.png) | ![midori logo](https://github.com/heckpsi-lab/em-midori/raw/master/.resources/murasaki_logo.png) |
|              Web Framework               |           Official Extensions            |         Modularized Event Engine         |
| [![Build Status](https://travis-ci.org/heckpsi-lab/em-midori.svg?branch=master)](https://travis-ci.org/heckpsi-lab/em-midori) | [![Build Status](https://travis-ci.org/heckpsi-lab/midori-contrib.svg?branch=master)](https://travis-ci.org/heckpsi-lab/midori-contrib) | [![Build Status](https://travis-ci.org/heckpsi-lab/murasaki.svg?branch=master)](https://travis-ci.org/heckpsi-lab/murasaki) |
| [![Test Coverage](https://codeclimate.com/github/heckpsi-lab/em-midori/badges/coverage.svg)](https://codeclimate.com/github/heckpsi-lab/em-midori/coverage) | [![Test Coverage](https://codeclimate.com/github/heckpsi-lab/midori-contrib/badges/coverage.svg)](https://codeclimate.com/github/heckpsi-lab/midori-contrib/coverage) | [![Test Coverage](https://codeclimate.com/github/heckpsi-lab/murasaki/badges/coverage.svg)](https://codeclimate.com/github/heckpsi-lab/murasaki/coverage) |
| [![Code Climate](https://codeclimate.com/github/heckpsi-lab/em-midori/badges/gpa.svg)](https://codeclimate.com/github/heckpsi-lab/em-midori) | [![Code Climate](https://codeclimate.com/github/heckpsi-lab/midori-contrib/badges/gpa.svg)](https://codeclimate.com/github/heckpsi-lab/midori-contrib) | [![Code Climate](https://codeclimate.com/github/heckpsi-lab/murasaki/badges/gpa.svg)](https://codeclimate.com/github/heckpsi-lab/murasaki) |
| [![Issue Count](https://codeclimate.com/github/heckpsi-lab/em-midori/badges/issue_count.svg)](https://codeclimate.com/github/heckpsi-lab/em-midori) | [![Issue Count](https://codeclimate.com/github/heckpsi-lab/midori-contrib/badges/issue_count.svg)](https://codeclimate.com/github/heckpsi-lab/midori-contrib) | [![Issue Count](https://codeclimate.com/github/heckpsi-lab/murasaki/badges/issue_count.svg)](https://codeclimate.com/github/heckpsi-lab/murasaki) |
| [![Dependency Status](https://gemnasium.com/badges/github.com/heckpsi-lab/em-midori.svg)](https://gemnasium.com/github.com/heckpsi-lab/em-midori) | [![Dependency Status](https://gemnasium.com/badges/github.com/heckpsi-lab/midori-contrib.svg)](https://gemnasium.com/github.com/heckpsi-lab/midori-contrib) | [![Dependency Status](https://gemnasium.com/badges/github.com/heckpsi-lab/murasaki.svg)](https://gemnasium.com/github.com/heckpsi-lab/murasaki) |
| [![doc](http://inch-ci.org/github/heckpsi-lab/em-midori.svg?branch=master)](http://inch-ci.org/github/heckpsi-lab/em-midori) | [![doc](http://inch-ci.org/github/heckpsi-lab/midori-contrib.svg?branch=master)](http://inch-ci.org/github/heckpsi-lab/midori-contrib) | [![doc](http://inch-ci.org/github/heckpsi-lab/murasaki.svg?branch=master)](http://inch-ci.org/github/heckpsi-lab/murasaki) |
| [![Gem Version](https://img.shields.io/gem/v/em-midori.svg?maxAge=43200)](https://rubygems.org/gems/em-midori) | [![Gem Version](https://img.shields.io/gem/v/midori-contrib.svg?maxAge=43200)](https://rubygems.org/gems/midori-contrib) | [![Gem Version](https://img.shields.io/gem/v/murasaki.svg?maxAge=43200)](https://rubygems.org/gems/murasaki) |
| [![Gem](https://img.shields.io/gem/dt/em-midori.svg?maxAge=43200)](https://rubygems.org/gems/em-midori) | [![Gem](https://img.shields.io/gem/dt/midori-contrib.svg?maxAge=43200)](https://rubygems.org/gems/midori-contrib) | [![Gem](https://img.shields.io/gem/dt/murasaki.svg?maxAge=43200)](https://rubygems.org/gems/murasaki) |
| [![license](https://img.shields.io/github/license/heckpsi-lab/em-midori.svg?maxAge=2592000)]() | [![license](https://img.shields.io/github/license/heckpsi-lab/midori-contrib.svg?maxAge=2592000)]() | [![license](https://img.shields.io/github/license/heckpsi-lab/murasaki.svg?maxAge=2592000)]() |

## Requirements

- **Ruby** >= 2.2.6

## Installation

```bash
gem install em-midori
```

**With Bundler**

```ruby
gem 'em-midori', require: 'midori'
```

```bash
bundle install
```

## FAQ

### Performance

Following benchmark results uses [em-midori-benchmark](https://github.com/heckpsi-lab/em-midori-benchmark), testing `{msg: "Hello"}` JSON response by visiting `GET /` with a **single-core, 4GB memory, UCloud Linux instance**.

**Note: Performance under Mac OS X needs to be further improved. `wrk` gives very bad performance result, but `ab` gives a good one. The following result is tested under Linux.**

| framework                    | version | req/s   |
| :--------------------------- | :------ | :------ |
| Rails (Thin, Ruby)           | 5.0.0.1 | 521.58  |
| Rails (API Mode, Thin, Ruby) | 5.0.0.1 | 760.03  |
| Sinatra (Thin, Ruby)         | 2.0.0   | 1912.23 |
| express.js (Node.js)         | 4.15.3  | 4944.58 |
| midori (Ruby)                | 0.2.4   | 3937.08 |

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

### Tutorial & Example

There is an unfinished tutorial available [here](https://github.com/heckpsi-lab/em-midori/tree/master/tutorial).

There is also an example showing how to use midori with a todo-list web app available [here](https://github.com/heckpsi-lab/midori-todo-example).

## Roadmap

**Development roadmap has been moved [here](https://github.com/heckpsi-lab/em-midori/wiki/Roadmap).**


**Detailed release notes for published versions can be seen [here](https://github.com/heckpsi-lab/em-midori/releases).**

## Midori 2 Goals

1. Support HTTP/2
2. Add MVC abstraction example with scaffold
3. Improve performance of eventloop
4. More examples on using midori

