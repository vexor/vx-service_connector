require 'base64'

module Vx
  module ServiceConnector
    class Github
      Commits = Struct.new(:session, :repo) do
        def last(options = {})
          begin
            project = session.repository(repo.full_name)
            branch  = project.default_branch || 'master'
            commit  = session.commit(repo.full_name, branch)
            Model::Payload.from_hash(
              skip:          false,
              pull_request?: false,
              branch:        branch,
              branch_label:  branch,
              sha:           commit.sha,
              message:       commit.commit.message,
              author:        commit.commit.author.name,
              author_email:  commit.commit.author.email,
              web_url:       commit.commit.url
            )
          rescue Octokit::NotFound
            nil
          end
        end
      end
    end
  end
end
