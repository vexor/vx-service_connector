require 'active_support/notifications'
require 'faraday'
require 'octokit/default'

builder = Faraday::RackBuilder.new
builder.request :instrumentation

Octokit::Default::MIDDLEWARE.request :instrumentation

Faraday.default_connection_options = {
  builder: builder
}
