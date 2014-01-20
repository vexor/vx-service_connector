require File.expand_path("../../lib/vx/service_connector", __FILE__)

Bundler.require(:test)

require 'rspec/autorun'
require 'webmock/rspec'

Dir[File.expand_path("../..", __FILE__) + "/spec/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rr
end
