# EM Midori

**This project is still under very early development, with NUMEROUS undecided syntax design and trivial implementation.**

**It's FAR from production-ready.**

**Improvement, Questions and Suggestions are highly welcomed.**

![Logo and Slogan](https://github.com/heckpsi-lab/em-midori/raw/master/.resources/slogan.png)

## Description

EM Midori is an EventMachine-based Web Framework written in pure Ruby, providing high performance and proper abstraction.

[![Join the chat at https://gitter.im/em-midori/Lobby](https://badges.gitter.im/em-midori/Lobby.svg)](https://gitter.im/em-midori/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Build Status](https://travis-ci.org/heckpsi-lab/em-midori.svg?branch=master)](https://travis-ci.org/heckpsi-lab/em-midori) [![Code Climate](https://codeclimate.com/github/heckpsi-lab/em-midori/badges/gpa.svg)](https://codeclimate.com/github/heckpsi-lab/em-midori) [![Test Coverage](https://codeclimate.com/github/heckpsi-lab/em-midori/badges/coverage.svg)](https://codeclimate.com/github/heckpsi-lab/em-midori/coverage) [![Issue Count](https://codeclimate.com/github/heckpsi-lab/em-midori/badges/issue_count.svg)](https://codeclimate.com/github/heckpsi-lab/em-midori)

[![Dependency Status](https://gemnasium.com/badges/github.com/heckpsi-lab/em-midori.svg)](https://gemnasium.com/github.com/heckpsi-lab/em-midori) [![doc](http://inch-ci.org/github/heckpsi-lab/em-midori.svg?branch=master)](http://inch-ci.org/github/heckpsi-lab/em-midori) [![yard](https://img.shields.io/badge/docs-yard-brightgreen.svg)](http://www.rubydoc.info/gems/em-midori)

[![Gem Version](https://img.shields.io/gem/v/em-midori.svg?maxAge=43200)](https://rubygems.org/gems/em-midori) [![Gem](https://img.shields.io/gem/dt/em-midori.svg?maxAge=43200)](https://rubygems.org/gems/em-midori) [![license](https://img.shields.io/github/license/heckpsi-lab/em-midori.svg?maxAge=2592000)]()

## Requirements

- **Ruby** >= 2.0.0 or **JRuby** >= 9.0.4.0 (Oracle JDK 7/8 or Open JDK 7/8) or **Rubinius** >= 3.20

## Installation

```bash
gem install em-midori
```

**With Bundler**

```ruby
gem 'em-midori'
```

```bash
bundle install
```

## Inspiration

### Why EventMachine Based

With the growing popularity of attempts of decoupling the front-end and back-end code, more and more people turn from full-stack web frameworks like Rails, to high performance API-based frameworks. We've got lots of choices in API-based frameworks, like Sinatra or Grape, but most of those are still working with multiple-threading model, which could hardly reach the I/O performance of Node.js or Go.

### DSL and MVC

DSL is awesome. With the magic of Ruby meta-programming features, we could make web development much easier. As lots of people say, EventMachine is fast but not that easy to use. But what if we build a DSL on top of it? You could then no longer have to deal with EventMachine directly. Midori is a project that builds a DSL on top of EventMachine. The API also provides an MVC project structure, for middle or large scale projects.

### Why not ... ?

#### Why not [cramp](https://github.com/lifo/cramp) ?

Cramp provides sinatra-like DSL and runs very fast on EventMachine for hello world benchmarks. But still it just packages the Network I/O part with EventMachine. It doesn't correctly deal with other I/O parts like database. So in practice, Cramp does not run as fast as it could. What's more, it's no longer maintained.

#### Why not [sinatra-synchrony](https://github.com/kyledrake/sinatra-synchrony) ?

Sinatra-synchrony perfectly combined Sinatra and EventMachine, but unfortunately, it also doesn't correctly deal with other I/O parts. With too many stacks combined, sinatra-synchrony has only about one-third performance of other EventMachine web servers. Not a good choice for production. What's more, it's also no longer maintained.

#### Why not [angelo](https://github.com/kenichi/angelo) ?

Angelo is awesome, providing Sinatra-like DSL for Reel. Actually Reel is not working with EventMachine, but [Celluloid::IO](https://github.com/celluloid/celluloid-io), which works similar to EventMachine. Angelo is not production ready, nor Reel or Celluloid::IO. There's also no clear roadmap showing when would they be ready, though none of them has declared out of maintaining.

### When Nothing Meet The Needs, Create One of Your Own.

## FAQ

### Performance

Following benchmark results are for [em-midori-benchmark](https://github.com/heckpsi-lab/em-midori-benchmark), testing `{msg: "Hello"}` JSON response by visiting `GET /` with a **single-core, 4GB memory, UCloud Linux instance**.

**Note: Performance under Mac OS X needs to be further confirmed. `wrk` gives very bad performance result, but `ab` gives a good one. The given result is tested under Linux.**

| framework                    | version | req/s   |
| :--------------------------- | :------ | :------ |
| Rails (Thin, Ruby)           | 5.0.0.1 | 464.81  |
| Rails (API Mode, Thin, Ruby) | 5.0.0.1 | 604.40  |
| Sinatra (Thin, Ruby)         | 1.4.7   | 1488.85 |
| express.js (Node.js)         | 4.14.0  | 3247.21 |
| em-midori (Ruby)             | 0.1.1   | 4159.84 |

### Name

**Midori** is none of the business of this guy

![Sapphire Kawashima](https://github.com/heckpsi-lab/em-midori/raw/master/.resources/sapphire_kawashima.gif)

and this guy.

![Midori Tokiwa](https://github.com/heckpsi-lab/em-midori/raw/master/.resources/midori_tokiwa.gif)

Actually the name **Midori** comes from **Midori machi**, which was the place I stay on my first travel to Tokyo.

### Version Notes

Version consists of four numbers:

|                 |           Main Code            |    Milestone Code     |          Feature Code           |           Hotfix            |
| --------------- | :----------------------------: | :-------------------: | :-----------------------------: | :-------------------------: |
| **Example**     |               1.               |          2.           |               1.                |              5              |
| **Explanation** | First Production Ready Version | Two Milestones Passed | One New Feature has been Staged | Five Releases for Bug Fixes |

### Contribution

Obey [Contributor Covenant Code of Conduct](CONTRIBUTOR_COVENANT_CODE_OF_CONDUCT.md) before you leave any comment.

#### Found a bug or any suggestion

1. Check [Issue list](https://github.com/heckpsi-lab/em-midori/issues).
2. Comment with your details if any ticket is common to your idea.
3. Raise a ticket if no open ticket meets your idea.
4. If you are not sure whether you should raise a ticket or not, use [gitter](https://gitter.im/em-midori/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) to contact other developers.

#### Contribute feature

1. Check [Issue list](https://github.com/heckpsi-lab/em-midori/issues) and [Development board](https://github.com/heckpsi-lab/em-midori/projects/1).
2. Pick a feature still not in progress.
3. Raise a ticket if your feature is still not on plan.
4. Fork it.
5. Code it.
6. Pass the tests.
7. Document it.
8. Raise pull requests.
9. If any problem, use [gitter](https://gitter.im/em-midori/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) to contact other developers.

## Roadmap

**Detailed release notes for published versions can be seen [here](https://github.com/heckpsi-lab/em-midori/releases).**

**Detailed progress can be seen [here](https://github.com/heckpsi-lab/em-midori/projects/1).**

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
|    0.1.5     |   2016-12-20    |                   | Implement Database ORM                 |
|    0.1.6     |   2017-01-03    |                   | Enrich Database                        |
|    0.1.7     |   2017-01-10    |                   | Enrich ORM                             |
|    0.1.8     |   2017-01-17    |                   | Tutorial                               |
|    0.1.9     |   2017-01-24    |                   | Official Wiki                          |
|    0.2.0     |   2017-01-31    |                   | Enrich API and documenting             |
|     ...      |       ...       |                   | ...                                    |
|  **1.0.0**   |     2017-03     |                   | First production-ready release         |
|    1.1.0     |     2017-06     |                   | TBD.                                   |
|    1.2.0     |     2017-09     |                   | TBD.                                   |

