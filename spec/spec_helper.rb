require File.expand_path("../../lib/vx/service_connector", __FILE__)

require 'rubygems'
require 'bundler'
Bundler.require

require 'rspec/autorun'
require 'webmock/rspec'

Dir[File.expand_path("../..", __FILE__) + "/spec/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.include ReadFixtureSpecSupport
end

ActiveSupport::Notifications.subscribe "request.faraday" do |name, started, finished, _, payload|
  env = {
    method:           payload[:method],
    url:              payload[:url].to_s,
    status:           payload[:status],
    response_headers: (payload[:response_headers] || []).map{|k,v| "#{k}: #{v}" }.join("\n"),
    request_headers:  payload[:request_headers].map{|k,v| "#{k}: #{v}" }.join("\n")
  }
  pp env
end
