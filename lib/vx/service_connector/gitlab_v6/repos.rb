module Vx
  module ServiceConnector
    class GitlabV6
      Repos = Struct.new(:session) do

        def to_a
          begin
            session.get("/projects", per_page: 30).map do |proj|
              proj_to_model proj
            end
          rescue RequestError
            []
          end
        end

        private

          def proj_to_model(repo)
            Model::Repo.new(
              repo.id,
              compute_name_with_namespace(repo),
              compute_is_private(repo),
              compute_ssh_url(repo),
              compute_web_url(repo),
              repo.description
            )
          end

          def compute_name_with_namespace(repo)
            if repo.path_with_namespace
              # for version 5.x
              repo.path_with_namespace
            else
              # for version 4.x
              hn = session.uri.hostname.to_s.split(".")[-2]
              hm ||= session.uri.hostname
              [hn, repo.name.downcase].join("/").downcase
            end
          end

          def compute_ssh_url(repo)
            if repo.ssh_url
              # for version 6.x
              repo.ssh_url
            else
              # for version 5.x or 4.x
              name = repo.path_with_namespace || repo.name
              "git@#{session.uri.hostname}:#{name.downcase}.git"
            end
          end

          def compute_web_url(repo)
            if repo.web_url
              # for version 6.x
              repo.web_url
            else
              # for version 5.x or 4.x
              name = repo.path_with_namespace || repo.name
              "#{session.uri.scheme}://#{session.uri.hostname}:#{session.uri.port}/#{name.downcase}"
            end
          end

          def compute_is_private(repo)
            case
              # for version before 6.x
            when repo.private != nil
              repo.private
              # for version 6.x
            when repo.public != nil
              !repo.public
            end
          end

      end
    end
  end
end
