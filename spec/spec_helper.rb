require 'simplecov'
SimpleCov.start
require 'coveralls'
Coveralls.wear!
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'em-midori'
