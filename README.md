# midori

**This project is still not production-ready. Questions, suggestions and pull requests are highly welcome.**

**🎉 Celebrate 10K downloads to midori.**

![Logo and Slogan](https://github.com/heckpsi-lab/em-midori/raw/master/.resources/slogan.png)

## Description

Midori is a Ruby Web Framework, providing high performance and proper abstraction.

[![Join the chat at https://gitter.im/em-midori/Lobby](https://img.shields.io/gitter/room/em-midori/Lobby.svg)](https://gitter.im/em-midori/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Build Status](https://travis-ci.org/heckpsi-lab/em-midori.svg?branch=master)](https://travis-ci.org/heckpsi-lab/em-midori) [![Code Climate](https://codeclimate.com/github/heckpsi-lab/em-midori/badges/gpa.svg)](https://codeclimate.com/github/heckpsi-lab/em-midori) [![Test Coverage](https://codeclimate.com/github/heckpsi-lab/em-midori/badges/coverage.svg)](https://codeclimate.com/github/heckpsi-lab/em-midori/coverage) [![Issue Count](https://codeclimate.com/github/heckpsi-lab/em-midori/badges/issue_count.svg)](https://codeclimate.com/github/heckpsi-lab/em-midori)

[![Dependency Status](https://gemnasium.com/badges/github.com/heckpsi-lab/em-midori.svg)](https://gemnasium.com/github.com/heckpsi-lab/em-midori) [![doc](http://inch-ci.org/github/heckpsi-lab/em-midori.svg?branch=master)](http://inch-ci.org/github/heckpsi-lab/em-midori) [![yard](https://img.shields.io/badge/docs-yard-brightgreen.svg)](http://www.rubydoc.info/gems/em-midori)

[![Gem Version](https://img.shields.io/gem/v/em-midori.svg?maxAge=43200)](https://rubygems.org/gems/em-midori) [![Gem](https://img.shields.io/gem/dt/em-midori.svg?maxAge=43200)](https://rubygems.org/gems/em-midori) [![license](https://img.shields.io/github/license/heckpsi-lab/em-midori.svg?maxAge=2592000)]()

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

### Contribution

Obey [Contributor Covenant Code of Conduct](CONTRIBUTOR_COVENANT_CODE_OF_CONDUCT.md) before you leave any comment.

#### Found a bug or any suggestion

1. Check [Issue list](https://github.com/heckpsi-lab/em-midori/issues).
2. Comment with your details if any ticket is common to your idea.
3. Raise a ticket if no open ticket meets your idea.
4. If you are not sure whether you should raise a ticket or not, use [gitter](https://gitter.im/em-midori/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) to contact other developers.

#### Contribute

1. Check [Issue list](https://github.com/heckpsi-lab/em-midori/issues).
2. Pick a feature still not in progress.
3. Raise a ticket saying you're working on.
4. Fork, Code, Test and Document it.
5. Raise pull requests.
6. If any problem, use [gitter](https://gitter.im/em-midori/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) to contact other developers.

### Tutorial & Example

There is an unfinished tutorial available [here](https://github.com/heckpsi-lab/em-midori/tree/master/tutorial).

There is also an example showing how to use midori with a todo-list web app available [here](https://github.com/heckpsi-lab/midori-todo-example).

## Roadmap

**Detailed release notes for published versions can be seen [here](https://github.com/heckpsi-lab/em-midori/releases).**

| Version Code | Determined Date |   Release Date    | Description                            |
| :----------: | :-------------: | :---------------: | -------------------------------------- |
|    0.0.1     |   2016-09-09    | 2016-09-09 (+0d)  | Init the gem project                   |
|    0.0.2     |   2016-09-09    | 2016-09-09 (+0d)  | Init basic EventMachine server         |
|    0.0.3     |   2016-09-13    | 2016-09-13 (+0d)  | Init Midori::API design                |
|    0.0.4     |   2016-09-20    | 2016-09-19 (-1d)  | Implement API match                    |
|    0.0.5     |   2016-09-27    | 2016-09-25 (-2d)  | Implement request and response.        |
|    0.0.6     |   2016-10-04    | 2016-10-06 (+2d)  | Implement WebSocket                    |
|    0.0.7     |   2016-10-11    | 2016-10-11 (+0d)  | Get WebSocket Code Covered             |
|    0.0.8     |   2016-10-18    | 2016-10-16 (-2d)  | Implement EventSource                  |
|    0.0.9     |   2016-10-25    | 2016-10-17 (-8d)  | Implement Middleware                   |
|  **0.1.0**   |   2016-11-01    | 2016-10-27 (-5d)  | Enrich API and documenting (dev ready) |
|    0.1.1     |   2016-11-08    | 2016-11-07 (-1d)  | API Mount Syntax                       |
|    0.1.2     |   2016-11-15    | 2016-11-27 (+12d) | Better Error Handler                   |
|    0.1.3     |   2016-11-22    | 2016-11-27 (+5d)  | File I/O                               |
|    0.1.4     |   2016-12-06    | 2016-11-28 (-8d)  | Implement Database Driver              |
|    0.1.5     |   2016-12-20    | 2016-12-01 (-19d) | Implement Database ORM                 |
|    0.1.6     |   2017-01-03    | 2016-12-21 (-13d) | Enrich Database                        |
|    0.1.7     |   2017-01-10    | 2016-12-25 (-16d) | Documenting                            |
|    0.1.8     |   2017-01-17    | 2017-01-17 (+0d)  | Tutorial (Partial)                     |
|    0.1.9     |   2017-02-21    | 2017-02-18 (-3d)  | Abstract Evented Actor                 |
|    0.1.10    |   2017-02-28    | 2017-02-20 (-8d)  | Reconstruct Extensions                 |
|    0.1.11    |   2017-03-07    | 2017-02-21 (-14d) | Add MySQL Extension Support            |
|    0.1.12    |   2017-03-14    | 2017-02-25 (-17d) | Better HTTP Request Extension          |
|    0.2.0     |   2017-03-21    | 2017-05-01 (+41d) | Fix stable problems                    |
|    0.2.1     |   2017-05-02    | 2017-05-02 (+0d)  | Improve doc                            |
|    0.2.2     |   2017-05-09    | 2017-05-12 (+3d)  | Better eventloop abstraction           |
|    0.2.3     |   2017-05-16    | 2017-06-04 (+19d) | Better network abstraction             |
|    0.2.4     |   2017-06-13    | 2017-06-06 (-7d)  | Improve Redis driver                   |
|    0.3.0     |   2017-06-20    |                   | Improve tutorial and documentation     |
|    0.3.1     |   2017-06-27    |                   | Enrich tests                           |
|  **1.0.0**   |   2017-07-04    |                   | **Stablize API, production ready**     |

## Midori 2 Goals

1. Support HTTP/2
2. Add MVC abstraction example with scaffold
3. Improve performance of eventloop
4. More examples on using midori

