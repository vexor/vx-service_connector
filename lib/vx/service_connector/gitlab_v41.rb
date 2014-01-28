require 'gitlab'

module Vx
  module ServiceConnector
    GitlabV41 = Struct.new(:endpoint, :private_token) do

      include ServiceConnector::Base

      def repos
        @repos ||= GitlabV41::Repos.new(session).to_a
      end

      def organizations
        []
      end

      def hooks(repo)
        GitlabV41::Hooks.new(session, repo)
      end

      def deploy_keys(repo)
        GitlabV41::DeployKeys.new(session, repo)
      end

      def notices(repo)
        GitlabV41::Notices.new(session, repo)
      end

      def files(repo)
        GitlabV41::Files.new(session, repo)
      end

      def commits(repo)
        GitlabV41::Commits.new(session, repo)
      end

      private

        def create_session
          GitlabV41::Session.new(endpoint, private_token)
        end

    end
  end
end

Dir[File.expand_path("../gitlab_v41/*.rb", __FILE__)].each do |f|
  require f
end
