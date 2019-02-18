require 'simplecov'
require 'rspec'
require 'pry'

# Start Simplecov
SimpleCov.start do
  add_filter 'spec/'
end

# Configure RSpec
RSpec.configure do |config|

  config.color = true
  config.fail_fast = false

  config.order = :random
  Kernel.srand config.seed

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

end

FIXTURES_PATH = File.expand_path('fixtures', __dir__)

def fixture_path(*args)
  File.join(FIXTURES_PATH, *args)
end

require 'yousign_api'
