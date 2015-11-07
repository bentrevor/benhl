ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'pry'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("lib/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
    mocks.verify_partial_doubles = true
    mocks.syntax = :expect
  end

  # so controller specs have methods like `get`, `post`, etc.
  config.infer_spec_type_from_file_location!

  config.use_transactional_fixtures = true
end
