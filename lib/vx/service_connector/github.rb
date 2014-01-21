require 'octokit'

Octokit.configure do |config|
  config.auto_paginate = true
end

module Vx
  module ServiceConnector
    class Github

      autoload :Hook,      File.expand_path("../github/hook",       __FILE__)
      autoload :DeployKey, File.expand_path("../github/deploy_key", __FILE__)
      autoload :Notice,    File.expand_path("../github/notice",     __FILE__)
      autoload :Repos,     File.expand_path("../github/repos",      __FILE__)

      attr_reader :login, :access_token

      def initialize(login, access_token)
        @login, @access_token = login, access_token
      end

      def repos
        @repos ||= Repos.new(session).to_a
      end

      def hooks(repo)
        Hook.new(session, repo)
      end

      def deploy_keys(repo)
        DeployKey.new(session, repo)
      end

      def notices(repo)
        Notice.new(session, repo)
      end

      private

        def session
          @session ||= create_session
        end

        def create_session
          Octokit::Client.new(login: login, access_token: access_token)
        end

    end
  end
end
