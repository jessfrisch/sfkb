$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require 'simplecov'
SimpleCov.start

require 'dotenv/load'

require 'vcr'
VCR.configure do |vcr|
  vcr.cassette_library_dir = 'test/cassettes'
  vcr.hook_into :faraday
  ENV.keys.grep(/^SALESFORCE_/).each do |var|
    vcr.filter_sensitive_data(var) { ENV[var] }
  end
end

require 'minitest-vcr'
MinitestVcr::Spec.configure!

require 'pry'

require 'minitest/autorun'
