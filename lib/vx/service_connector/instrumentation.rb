require 'active_support/notifications'

module Vx
  module ServiceConnector
    class Instrumentation < Faraday::Middleware

      def initialize(app, options = {})
        super(app)
        @name = options.fetch(:name, 'request.http')
      end

      def call(env)
        trace_env = {
          method:           env[:method],
          url:              env[:url].to_s,
          status:           env[:status],
          response_headers: env[:response_headers].map{|k,v| "#{k}: #{v}" }.join("\n")
        }
        puts "ENV: #{env.inspect}"
        ActiveSupport::Notifications.instrument(@name, trace_env) do
          @app.call(env)
        end
      end
    end
  end
end

require 'octokit/default'
Octokit::Default::MIDDLEWARE.use Vx::ServiceConnector::Instrumentation
