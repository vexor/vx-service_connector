module Vx
  module ServiceConnector
    class GitlabV4
      Repos = Struct.new(:session) do

        def to_a
          session.get("/projects").map do |proj|
            proj_to_model proj
          end
        end

        private

          def proj_to_model(repo)
            Model::Repo.new(
              repo.id,
              compute_name_with_namespace(repo),
              repo.private,
              compute_ssh_url(repo),
              compute_web_url(repo),
              repo.description
            )
          end

          def compute_name_with_namespace(repo)
            [session.uri.hostname, repo.name.downcase].join("/")
          end

          def compute_ssh_url(repo)
            "git@#{session.uri.hostname}:#{repo.name.downcase}.git"
          end

          def compute_web_url(repo)
            "#{session.uri.scheme}://#{session.uri.hostname}:#{session.uri.port}/#{repo.name.downcase}"
          end

      end
    end
  end
end
