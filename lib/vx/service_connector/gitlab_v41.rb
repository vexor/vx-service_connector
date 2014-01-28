require 'gitlab'

module Vx
  module ServiceConnector
    GitlabV41 = Struct.new(:endpoint, :private_token) do

      include ServiceConnector::Base

      def repos
        @repos ||= GitlabV41::Repos.new(session).to_a
      end

      def deploy_keys(repo)
        GitlabV41::DeployKeys.new(session, repo)
      end

      private

        def create_session
          GitlabV41::Session.new(endpoint, private_token)
        end

    end
  end
end

%w{ repos deploy_keys session }.each do |f|
  require File.expand_path("../gitlab_v41/#{f}", __FILE__)
end
