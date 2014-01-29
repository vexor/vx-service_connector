require 'base64'

module Vx
  module ServiceConnector
    class GitlabV4
      Commits = Struct.new(:session, :repo) do

        def get(sha)
          begin
            all_commits = session.get "/projects/#{repo.id}/repository/commits", ref_name: sha
            commits_to_model all_commits
          rescue RequestError => e
            $stderr.puts "ERROR: #{e.inspect}"
            nil
          end
        end

        private

          def commits_to_model(commits)
            if commit = commits.first
              Model::Commit.new(
                commit.id,
                commit.title,
                commit.author_name,
                commit.author_email,
                nil
              )
            end
          end

      end
    end
  end
end
