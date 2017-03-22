require "bundler/setup"
require File.expand_path("../lib/jekyll-absolute-links", File.dirname(__FILE__))

Jekyll.logger.log_level = :error

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
