module Vx
  module ServiceConnector
    class Bitbucket
      Repos = Struct.new(:session) do

        def to_a
          @repos ||= all_repos
        end

        private

          def path(p)
            "api/2.0/#{p}?role=admin&pagelen=100"
          end

          def teams
            res = session.get(path "teams")

            if list = res["values"]
              list.map { |team| team["username"] }
            else
              []
            end
          end

          def all_repos
            all_teams = [login] + teams
            all_teams.map do |name|
              Thread.new do
                by_username(name)
              end.tap do |t|
                t.abort_on_exception = true
              end
            end.flat_map(&:value)
          end

          def by_username(name)
            res = session.get(path "repositories/#{name}")
            if values = res["values"]
              make_repos_list(values)
            else
              []
            end
          end

          def make_repos_list(values)
            values.reduce([]) do |repos, repo|
              if git?(repo)
                repos << repo_to_model(repo)
              else
                repos
              end
            end
          end

          def repo_to_model(repo)
            name = repo["full_name"]
            Model::Repo.new(
              name,
              name,
              repo['is_private'],
              "git@#{session.endpoint.host}:#{name}.git",
              "#{session.endpoint}/#{name}",
              repo['description'],
              repo_language(repo)
            )
          end

          def login
            session.login
          end

          def repo_language(repo)
            repo['language'] == '' ? nil : repo['language']
          end

          def git?(repo)
            repo['scm'] == 'git'
          end

      end
    end
  end
end
