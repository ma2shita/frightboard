require_relative File.join("..", "init")
require_relative File.join("..", "applib")

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

require "rspec/its"
require "rspec/json_matcher"
RSpec.configuration.include RSpec::JsonMatcher

require "rack/test"
include Rack::Test::Methods
