module Vx
  module ServiceConnector
    class Github
      class Repos
        attr_reader :session

        def initialize(session)
          @session = session
        end

        def to_a
          @repos ||= (user_repositories + organization_repositories)
        end

        def organizations
          session.organizations.map(&:login) || []
        end

        def organization_repositories
          organizations.map do |org|
            Thread.new do
              session.organization_repositories(org)
                     .reject { |repo| not repo.permissions.admin }
                     .map { |repo| repo_to_model repo }
            end.tap do |th|
              th.abort_on_exception = true
            end
          end.map(&:value).flatten
        end

        def user_repositories
          session.repositories.map do |repo|
            repo_to_model repo
          end
        end

        def repo_to_model(repo)
          Model::Repo.new(repo.full_name, repo.private, repo.rels[:ssh].href, repo.rels[:html].href)
        end

      end
    end
  end
end
