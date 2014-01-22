module Vx
  module ServiceConnector
    class Github
      Commits = Struct.new(:session, :repo) do

        def get(sha)
          begin
            commit = session.commit repo.full_name, sha
            commit_to_model commit
          rescue ::Octokit::NotFound => e
            $stderr.puts "ERROR: #{e.inspect}"
            nil
          end
        end

        private

          def commit_to_model(commit)
            url = commit.rels[:html]

            Model::Commit.new(
              commit.sha,
              commit.commit.message,
              commit.commit.author.name,
              commit.commit.author.email,
              url && url.href
            )
          end

      end
    end
  end
end
