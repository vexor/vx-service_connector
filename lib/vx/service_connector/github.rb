require 'octokit'

Octokit.configure do |config|
  config.auto_paginate = true
end

module Vx
  module ServiceConnector
    Github = Struct.new(:login, :access_token) do

      include ServiceConnector::Base

      def repos
        Github::Repos.new(session).to_a
      end

      def organizations
        Github::Repos.new(session).organizations
      end

      def hooks(repo)
        Github::Hooks.new(session, repo)
      end

      def deploy_keys(repo)
        Github::DeployKeys.new(session, repo)
      end

      def notices(repo)
        Github::Notices.new(session, repo)
      end

      def files(repo)
        Github::Files.new(session, repo)
      end

      def payload(repo, params)
        Github::Payload.new(session, params).build
      end

      def commits(repo, options = {})
        Github::Commits.new(session, repo)
      end

      private

        def create_session
          Octokit::Client.new(login: login, access_token: access_token)
        end

    end
  end
end

Dir[File.expand_path("../github/*.rb", __FILE__)].each do |f|
  require f
end
