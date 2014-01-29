require 'gitlab'

module Vx
  module ServiceConnector
    class GitlabV5 < GitlabV4

      def repos
        @repos ||= GitlabV4::Repos.new(session).to_a
      end

      def deploy_keys(repo)
        GitlabV5::DeployKeys.new(session, repo)
      end

    end
  end
end

Dir[File.expand_path("../gitlab_v5/*.rb", __FILE__)].each do |f|
  require f
end
