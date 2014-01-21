module Vx
  module ServiceConnector
    class GitlabV3
      Repos = Struct.new(:session) do

        def to_a
          session.projects.map do |proj|
            proj_to_model proj
          end
        end

        private

          def proj_to_model(repo)
            Model::Repo.new(repo.id,
                            repo.path_with_namespace,
                            true,
                            repo.ssh_url_to_repo,
                            repo.web_url)
          end

      end
    end
  end
end
