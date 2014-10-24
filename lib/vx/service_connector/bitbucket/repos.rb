module Vx
  module ServiceConnector
    class Bitbucket
      Repos = Struct.new(:session) do

        def to_a
          @repos ||= user_repositories
        end

        private

          def user_repositories
            begin
              res = session.get("api/1.0/user/repositories")
              res.select do |repo|
                git?(repo) && repo_access?(repo['owner'])
              end.map do |repo|
                repo_to_model repo
              end
            rescue Vx::ServiceConnector::RequestError
              []
            end
          end

          def repo_to_model(repo)
            name = repo['owner'] + "/" + repo['slug']
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

          def team_admin
            @team_admin ||= begin
              values = session.get("api/1.0/user/privileges")['teams']
              values = values.select{|k,v| v == 'admin' }.keys
              values
            end
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

          def repo_access?(repo_owner)
            (repo_owner == login) ||
              team_admin.include?(repo_owner)
          end

      end
    end
  end
end
