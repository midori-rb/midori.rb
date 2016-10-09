require 'simplecov'
require 'codeclimate-test-reporter'
require 'bundler/setup'

SimpleCov.start do
  add_filter '/spec/'
end
CodeClimate::TestReporter.start
Bundler.require

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.on_potential_false_positives = :nothing
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
