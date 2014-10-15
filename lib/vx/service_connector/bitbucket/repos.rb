module Vx
  module ServiceConnector
    class Bitbucket
      Repos = Struct.new(:session) do

        def to_a
          @repos ||= user_repositories
        end

        private

        def user_repositories
          login = self.session.login
          teams = session.get("https://bitbucket.org/api/1.0/user/privileges").teams
          res = session.get("https://bitbucket.org/api/1.0/user/repositories?pagelen=100")
          res.values.map do |repo|
            if repo_access?(repo.owner.username, login, teams) && repo.scm == 'git'
              repo_to_model repo
            end
          end.compact
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

        def repo_access?(repo_owner, login, teams)
          repo_owner == login || teams.to_hash.select{|_, value| value == 'admin'}.has_key?(repo_owner.to_sym)
        end

      end
    end
  end
end
