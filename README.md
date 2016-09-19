# EM Midori
## Description

EM Midori is an EventMachine-based Web Framework written in pure Ruby, which provides high performance while proper abstraction.

[![Join the chat at https://gitter.im/em-midori/Lobby](https://badges.gitter.im/em-midori/Lobby.svg)](https://gitter.im/em-midori/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Build Status](https://travis-ci.org/heckpsi-lab/em-midori.svg?branch=master)](https://travis-ci.org/heckpsi-lab/em-midori) [![Code Climate](https://codeclimate.com/github/heckpsi-lab/em-midori/badges/gpa.svg)](https://codeclimate.com/github/heckpsi-lab/em-midori) [![Test Coverage](https://codeclimate.com/github/heckpsi-lab/em-midori/badges/coverage.svg)](https://codeclimate.com/github/heckpsi-lab/em-midori/coverage) [![Issue Count](https://codeclimate.com/github/heckpsi-lab/em-midori/badges/issue_count.svg)](https://codeclimate.com/github/heckpsi-lab/em-midori)

[![Gem Version](https://img.shields.io/gem/v/em-midori.svg?maxAge=2592000)](https://rubygems.org/gems/em-midori) [![Gem](https://img.shields.io/gem/dt/em-midori.svg?maxAge=2592000)](https://rubygems.org/gems/em-midori) [![license](https://img.shields.io/github/license/heckpsi-lab/em-midori.svg?maxAge=2592000)]()

## Requirements

- Ruby >= 2.0.0
- JRuby >= 9.0.4.0 (With Oracle JDK 7 or Open JDK 7)
- Rubinius >= 3.20
- JRuby Truffle (Probably support on intuition, but still not tested)

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

### EventMachine Based



### DSL and MVC



### Why not ... ?

#### Why not [sinatra-synchrony](https://github.com/kyledrake/sinatra-synchrony) ?

#### Why not Angelo



## FAQ

### Name

**Midori** is none of the business

### Version Notes

Version code includes four codes

|                 |           Main Code            |    Milestone Code     |          Feature Code           |           Hotfix            |
| --------------- | :----------------------------: | :-------------------: | :-----------------------------: | :-------------------------: |
| **Example**     |               1.               |          2.           |               1.                |              5              |
| **Explanation** | First Production Ready Version | Two Milestones Passed | One New Feature has been Staged | Five Releases for Bug Fixes |

## Contribution



## Goals

- Sinatra-like DSL
- MVC Abstraction
- 100% Code Coverage
- Test Driven Framework
- Event Machine I/O
- Event Machine Database I/O

## Roadmap

**Note: Detailed release note for published version could be seen at [here](https://github.com/heckpsi-lab/em-midori/releases).**

| Version Code | Determined Date | Release Date | Description                              |
| :----------: | :-------------: | :----------: | ---------------------------------------- |
|    0.0.1     |   2016-09-09    |  2016-09-09  | Init the gem project                     |
|    0.0.2     |   2016-09-09    |  2016-09-09  | Init basic EventMachine server           |
|    0.0.3     |   2016-09-13    |  2016-09-13  | Init Midori::API design                  |
|    0.0.4     |   2016-09-20    |  2016-09-19  | Implement API match                      |
|    0.0.5     |   2016-09-27    |   Not Yet    | Implement basic request and response parse. |
|    0.0.6     |   2016-10-04    |              | Implement middleware injection           |
|    0.0.7     |   2016-10-11    |              | Stabilize API design                     |
|    0.0.8     |   2016-10-18    |              | Enrich Implementation with API design    |
|    0.0.9     |   2016-10-25    |              | Issue killing in a week                  |
|  **0.1.0**   |   2016-11-01    |              | First development-ready release          |
|    0.1.1     |   2016-11-15    |              | Implement Midori::Database IO            |
|     ...      |       ...       |              | ...                                      |
|  **1.0.0**   |     2017-03     |              | First production-ready release           |
|    1.1.0     |     2017-06     |              | TBD.                                     |
|    1.2.0     |     2017-09     |              | TBD.                                     |

