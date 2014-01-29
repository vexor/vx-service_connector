require 'gitlab'

module Vx
  module ServiceConnector
    GitlabV4 = Struct.new(:endpoint, :private_token) do

      include ServiceConnector::Base

      def repos
        @repos ||= GitlabV4::Repos.new(session).to_a
      end

      def organizations
        []
      end

      def hooks(repo)
        GitlabV4::Hooks.new(session, repo)
      end

      def deploy_keys(repo)
        GitlabV4::DeployKeys.new(session, repo)
      end

      def notices(repo)
        GitlabV4::Notices.new(session, repo)
      end

      def files(repo)
        GitlabV4::Files.new(session, repo)
      end

      def commits(repo)
        GitlabV4::Commits.new(session, repo)
      end

      private

        def create_session
          GitlabV4::Session.new(endpoint, private_token)
        end

    end
  end
end

Dir[File.expand_path("../gitlab_v4/*.rb", __FILE__)].each do |f|
  require f
end
