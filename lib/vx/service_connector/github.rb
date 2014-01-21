require 'octokit'

Octokit.configure do |config|
  config.auto_paginate = true
end

module Vx
  module ServiceConnector
    Github = Struct.new(:login, :access_token) do

      include ServiceConnector::Base

      def repos
        @repos ||= Github::Repos.new(session).to_a
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

      private

        def create_session
          Octokit::Client.new(login: login, access_token: access_token)
        end

    end
  end
end

%w{ hooks deploy_keys notices repos payload }.each do |f|
  require File.expand_path("../github/#{f}", __FILE__)
end
