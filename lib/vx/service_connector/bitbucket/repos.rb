module Vx
  module ServiceConnector
    class Bitbucket
      Repos = Struct.new(:session) do

        def to_a
          @repos ||= (user_repositories + organization_repositories)
        end

        def organizations
          privileges = session.get "https://bitbucket.org/api/1.0/user/privileges"
          privileges.teams.to_attrs.select{ |_, access| access == 'admin' }.keys
        end

        def organization_repositories
          organizations.map do |team|
            res = session.get("https://bitbucket.org/api/2.0/repositories/#{team}?pagelen=100")
            res.values.map { |repo| repo_to_model repo }
          end.flatten
          ###
        end

        def user_repositories
          res = session.get("https://bitbucket.org/api/1.0/user/repositories?pagelen=100")
          res.values.map { |repo| repo_to_model repo }
        end

        def repo_to_model(repo)
          Model::Repo.new(
            repo.uuid,
            repo.full_name,
            repo.is_private,
            repo.links.clone.last.href,
            repo.links.html.href,
            repo.description
          )
        end

      end
    end
  end
end
