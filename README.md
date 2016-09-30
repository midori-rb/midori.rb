# EM Midori

![Logo and Slogan](https://raw.githubusercontent.com/heckpsi-lab/em-midori/master/.resources/slogan.png)

## Description

EM Midori is an EventMachine-based Web Framework written in pure Ruby, which provides high performance and proper abstraction.

[![Join the chat at https://gitter.im/em-midori/Lobby](https://badges.gitter.im/em-midori/Lobby.svg)](https://gitter.im/em-midori/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Build Status](https://travis-ci.org/heckpsi-lab/em-midori.svg?branch=master)](https://travis-ci.org/heckpsi-lab/em-midori) [![Code Climate](https://codeclimate.com/github/heckpsi-lab/em-midori/badges/gpa.svg)](https://codeclimate.com/github/heckpsi-lab/em-midori) [![Test Coverage](https://codeclimate.com/github/heckpsi-lab/em-midori/badges/coverage.svg)](https://codeclimate.com/github/heckpsi-lab/em-midori/coverage) [![Issue Count](https://codeclimate.com/github/heckpsi-lab/em-midori/badges/issue_count.svg)](https://codeclimate.com/github/heckpsi-lab/em-midori)

[![Gem Version](https://img.shields.io/gem/v/em-midori.svg?maxAge=43200)](https://rubygems.org/gems/em-midori) [![Gem](https://img.shields.io/gem/dt/em-midori.svg?maxAge=43200)](https://rubygems.org/gems/em-midori) [![license](https://img.shields.io/github/license/heckpsi-lab/em-midori.svg?maxAge=2592000)]()

## Requirements

- **Ruby** >= 2.0.0 or **JRuby** >= 9.0.4.0 (Oracle JDK 7/8 or Open JDK 7/8) or **Rubinius** >= 3.20

## Installation

```bash
gem install em-midori
```

**With Bundle**

```ruby
gem 'em-midori'
```

```bash
bundle install
```

## Inspiration

### Why EventMachine Based

With the growing popularity of attempts of decoupling the front-end and back-end code has made more and more people turns to high performance API-based framework from full-stack web framework like Rails. Since we've got lots of choices in API-based frameworks like Sinatra or Grape. But most of those are still working with multiple-threading model, which could hardly reach I/O performance like Node.js or Go does.

### DSL and MVC

DSL is awesome. With the magics of Ruby meta-programming feature, we could make web development much easier. As lots of people saying, EventMachine is fast but not that easy to use. But what if we build a DSL on it, you could then no longer deal anything with EventMachine directly. Midori is a project that would build DSL on EventMachine. The API would also provide an MVC project structure, for middle or large scale projects.

### Why not ... ?

#### Why not [cramp](https://github.com/lifo/cramp) ?

Cramp provides sinatra-like DSL and runs very fast on EventMachine for hello world benchmarks. But still it just packages the Network I/O part with EventMachine. It doesn't correctly deal with other I/O parts like database. So in practice, Cramp does not runs as fast as it could be. What's more, it's no longer maintained.

#### Why not [sinatra-synchrony](https://github.com/kyledrake/sinatra-synchrony) ?

Sinatra-synchrony perfectly combined Sinatra and EventMachine, but unfortunately, it also doesn't correctly deal with other I/O parts. With too many stacks combined, sinatra-synchrony has only about one-third performance of other EventMachine web servers. Not a good choice for production. What's more, it's also no longer maintained.

#### Why not [angelo](https://github.com/kenichi/angelo) ?

Angelo is awesome, providing Sinatra-like DSL for Reel. Actually Reel is not working with EventMachine, but [Celluloid::IO](https://github.com/celluloid/celluloid-io), which works similar to EventMachine. Angelo is not production ready, nor Reel or Celluloid::IO. There's also no clear roadmap showing when would they be ready, though none of them has declared out of maintaining.

### When Nothing Meet The Needs, Create One of Your Own.

## FAQ

### Name

**Midori** is none of the business of this guy

![Sapphire Kawashima](https://raw.githubusercontent.com/heckpsi-lab/em-midori/master/.resources/sapphire_kawashima.gif)

and this guy.

![Midori Tokiwa](https://raw.githubusercontent.com/heckpsi-lab/em-midori/master/.resources/midori_tokiwa.gif)

Actually the name **Midori** comes from **Midori machi**, which was the place I stay on my first travel to Tokyo.

### Version Notes

Version code includes four codes

|                 |           Main Code            |    Milestone Code     |          Feature Code           |           Hotfix            |
| --------------- | :----------------------------: | :-------------------: | :-----------------------------: | :-------------------------: |
| **Example**     |               1.               |          2.           |               1.                |              5              |
| **Explanation** | First Production Ready Version | Two Milestones Passed | One New Feature has been Staged | Five Releases for Bug Fixes |

### Contribution

#### Found a bug or any suggestion

1. Check [Issue list](https://github.com/heckpsi-lab/em-midori/issues).
2. Comment with your details if any ticket is common to your idea.
3. Raise a ticket if no open ticket meets your idea.
4. If you are not sure whether you should raise a ticket or not, use [gitter](https://gitter.im/em-midori/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) to contact other developers.

#### Code Improvement

1. Check [Issue list](https://github.com/heckpsi-lab/em-midori/issues).
2. Check Roadmap.
3. Pick a ticket and leaves a comment saying you are working on it.
4. If it's on roadmap but not ticket raised, raise a ticket.
5. Fork it.
6. Code it.
7. Pass the tests.
8. Document it.
9. Raise pull requests.
10. If any problem, use [gitter](https://gitter.im/em-midori/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) to contact other developers.

## Roadmap

**Note: Detailed release note for published version could be seen at [here](https://github.com/heckpsi-lab/em-midori/releases).**

| Version Code | Determined Date |   Release Date   | Description                              |
| :----------: | :-------------: | :--------------: | ---------------------------------------- |
|    0.0.1     |   2016-09-09    |    2016-09-09    | Init the gem project                     |
|    0.0.2     |   2016-09-09    |    2016-09-09    | Init basic EventMachine server           |
|    0.0.3     |   2016-09-13    |    2016-09-13    | Init Midori::API design                  |
|    0.0.4     |   2016-09-20    | 2016-09-19 (-1d) | Implement API match                      |
|    0.0.5     |   2016-09-27    | 2016-09-25 (-2d) | Implement basic request and response parse. |
|    0.0.6     |   2016-10-04    |                  | Implement WebSocket and EventSource      |
|    0.0.7     |   2016-10-11    |                  | Implement middleware injection           |
|    0.0.8     |   2016-10-18    |                  | Enrich Implementation with API design    |
|    0.0.9     |   2016-10-25    |                  | Stablize API design                      |
|  **0.1.0**   |   2016-11-01    |                  | Bug killing and documenting (dev ready)  |
|    0.1.1     |   2016-11-15    |                  | Implement Midori::Database IO            |
|     ...      |       ...       |                  | ...                                      |
|  **1.0.0**   |     2017-03     |                  | First production-ready release           |
|    1.1.0     |     2017-06     |                  | TBD.                                     |
|    1.2.0     |     2017-09     |                  | TBD.                                     |

