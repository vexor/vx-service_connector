module Vx
  module ServiceConnector
    GitlabV6 = Struct.new(:endpoint, :private_token) do

      include ServiceConnector::Base

      def repos
        @repos ||= self.class::Repos.new(session).to_a
      end

      def organizations
        []
      end

      def hooks(repo)
        self.class::Hooks.new(session, repo)
      end

      def deploy_keys(repo)
        self.class::DeployKeys.new(session, repo)
      end

      def notices(repo)
        self.class::Notices.new(session, repo)
      end

      def files(repo)
        self.class::Files.new(session, repo)
      end

      def payload(repo, params)
        self.class::Payload.new(session, repo, params).build
      end

      private

        def create_session
          self.class::Session.new(endpoint, private_token)
        end
    end
  end
end

Dir[File.expand_path("../gitlab_v6/*.rb", __FILE__)].each do |f|
  require f
end
