module Vx
  module ServiceConnector
    class GitlabV4
      Repos = Struct.new(:session) do

        def to_a
          begin
            session.get("/projects").map do |proj|
              proj_to_model proj
            end
          rescue MultiJson::LoadError => e
            $stderr.puts "ERROR: #{e.inspect}"
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
              repo.path_with_namespace
            else
              hn = session.uri.hostname.to_s.split(".")[-2]
              hm ||= session.uri.hostname
              [hn, repo.name.downcase].join("/")
            end
          end

          def compute_ssh_url(repo)
            if repo.ssh_url
              repo.ssh_url
            else
              "git@#{session.uri.hostname}:#{repo.name.downcase}.git"
            end
          end

          def compute_web_url(repo)
            if repo.web_url
              repo.web_url
            else
              "#{session.uri.scheme}://#{session.uri.hostname}:#{session.uri.port}/#{repo.name.downcase}"
            end
          end

          def compute_is_private(repo)
            case
            when repo.private != nil
              repo.private
            when repo.public != nil
              !repo.public
            end
          end

      end
    end
  end
end
