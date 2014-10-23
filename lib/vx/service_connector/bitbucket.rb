module Vx
  module ServiceConnector
    Bitbucket = Struct.new(:login, :options) do

      include ServiceConnector::Base

      def repos
        Bitbucket::Repos.new(session).to_a
      end

      def organizations
        []
      end

      def hooks(repo)
        Bitbucket::Hooks.new(session, repo)
      end

      def deploy_keys(repo)
        Bitbucket::DeployKeys.new(session, repo)
      end

      def notices(repo)
        Bitbucket::Notices.new(session, repo)
      end

      def files(repo)
        Bitbucket::Files.new(session, repo)
      end

      def payload(repo, params)
        Bitbucket::Payload.new(session, params).build
      end

      def commits(repo, options = {})
        Bitbucket::Commits.new(session, repo)
      end

      private

        def create_session
          self.class::Session.new(login, options)
        end

    end
  end
end

Dir[File.expand_path("../bitbucket/*.rb", __FILE__)].each do |f|
  require f
end
