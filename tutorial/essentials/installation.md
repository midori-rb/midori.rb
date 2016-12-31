# Installation

## Requirements

Open up a command line prompt. Any commands prefaced with a dollar sign `$` should be run in the command line. Verify that you have a current version of Ruby installed:

```
 $ ruby -v
 ruby 2.4.0p0
```

Generally, midori supports the following ruby interpreters:

- Ruby (MRI) **>= 2.1.0**
- JRuby >= **9.0.4.0**

 For every version released, it would be tested and **officially ensured** in the following environments:

- Ruby
  - 2.1.0
  - 2.2.6
  - 2.3.3
  - 2.4.0
- JRuby
  - 9.0.4.0, OpenJDK 7
  - 9.0.4.0, OracleJDK 7
  - 9.0.4.0, OracleJDK 8

**Note: **

- **For JRuby users, you may meet performance problem due to the issues of [Fiber implementation](https://github.com/jruby/jruby/wiki/DifferencesBetweenMriAndJruby#continuations-and-fibers) with JVM, which may [possibly improved](https://github.com/jruby/jruby/wiki/PerformanceTuning#enable-coroutine-based-fibers) in the future JRuby versions with JDK 9.**
- **For macOS users, you may meet performance problem due to the issues of [EventMachine](https://github.com/heckpsi-lab/em-midori/issues/15). Very few people would use macOS in production, so this issue may not affect much, but we are still working hard on fixing it.**

It's hard to say that if it is possible for running on other ruby implementations like Rubinius, if you're in favor of supporting more ruby implementations, you could open a ticket [here](https://github.com/heckpsi-lab/em-midori/issues), and we are glad to discuss it.

## Install with RubyGems

```
$ gem install em-midori
Successfully installed em-midori-0.1.7
1 gem installed
```

To test whether it has installed properly, run:

```
$ ruby -r "midori" -e "class A < Midori::API;end;Midori::Runner.new(A).start"
```

If you see the following message, then everything now works fine.

```
Midori 0.1.7 is now running on 127.0.0.1:8080
```

## Use Bundler