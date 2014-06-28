require 'active_support/notifications'
require 'faraday'
require 'octokit/default'

Octokit::Default::MIDDLEWARE.insert 0, Faraday::Request::Instrumentation

builder = Faraday::RackBuilder.new
builder.insert 0, Faraday::Request::Instrumentation

Faraday.default_connection_options = {
  builder: builder
}
