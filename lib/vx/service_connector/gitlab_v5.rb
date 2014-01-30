require 'gitlab'

module Vx
  module ServiceConnector
    GitlabV5 = Struct.new(:endpoint, :private_token) do

      include ServiceConnector::Base

      def repos
        @repos ||= GitlabV5::Repos.new(session).to_a
      end

      def organizations
        []
      end

      def hooks(repo)
        GitlabV5::Hooks.new(session, repo)
      end

      def deploy_keys(repo)
        GitlabV5::DeployKeys.new(session, repo)
      end

      def notices(repo)
        GitlabV5::Notices.new(session, repo)
      end

      def files(repo)
        GitlabV5::Files.new(session, repo)
      end

      def payload(repo, params)
        GitlabV5::Payload.new(session, repo, params)
      end

      private

        def create_session
          GitlabV5::Session.new(endpoint, private_token)
        end

    end
  end
end

Dir[File.expand_path("../gitlab_v5/*.rb", __FILE__)].each do |f|
  require f
end
