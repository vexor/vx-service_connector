module Vx
  module ServiceConnector
    class Github
      Repos = Struct.new(:session) do

        def to_a
          @repos ||= (user_repositories + organization_repositories)
        end

        def organizations
          begin
            session.organizations.map(&:login) || []
          rescue Octokit::Unauthorized
            []
          end
        end

        def organization_repositories
          organizations.map do |org|
            Thread.new do
              begin
                session.organization_repositories(org)
                       .reduce([], &filter_repos)
              rescue Octokit::Unauthorized
                []
              end
            end.tap do |th|
              th.abort_on_exception = true
            end
          end.flat_map(&:value)
        end

        def filter_repos
          ->(repos, repo) {
            if repo.permissions && repo.permissions.admin
              repos << repo_to_model(repo)
            else
              repos
            end
          }
        end

        def user_repositories
          begin
            session.repositories.reduce([], &filter_repos)
          rescue Octokit::Unauthorized
            []
          end
        end

        def repo_to_model(repo)
          Model::Repo.new(
            repo.id,
            repo.full_name,
            repo.private,
            repo.rels[:ssh].href,
            repo.rels[:html].href,
            repo.description,
            repo.language
          )
        end

      end
    end
  end
end
