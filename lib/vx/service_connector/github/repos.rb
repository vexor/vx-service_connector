module Vx
  module ServiceConnector
    class Github
      Repos = Struct.new(:session) do

        def to_a
          @repos ||= (user_repositories + organization_repositories)
        end

        def organizations
          session.organizations.map(&:login) || []
        end

        def organization_repositories
          organizations.map do |org|
            Thread.new do
              session
                .organization_repositories(org)
                .select { |repo| repo.permissions && repo.permissions.admin }
                .map { |repo| repo_to_model repo }
            end.tap do |th|
              th.abort_on_exception = true
            end
          end.map(&:value).flatten
        end

        def user_repositories
          session.repositories
            .select { |repo| repo.permissions && repo.permissions.admin }
            .map { |repo| repo_to_model repo }
        end

        def repo_to_model(repo)
          Model::Repo.new(
            repo.id,
            repo.full_name,
            repo.private,
            repo.rels[:ssh].href,
            repo.rels[:html].href,
            repo.description
          )
        end

      end
    end
  end
end
