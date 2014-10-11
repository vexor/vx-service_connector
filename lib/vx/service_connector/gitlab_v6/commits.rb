module Vx
  module ServiceConnector
    class GitlabV6
      Commits = Struct.new(:session, :repo) do

        def last(options = {})
          begin
            project = session.get "/projects/#{repo.id}"
            branch  = project.default_branch || "master"
            commit  = session.get "/projects/#{repo.id}/repository/commits/#{branch}"
            Model::Payload.from_hash(
              skip:          false,
              pull_request?: false,
              branch:        branch,
              branch_label:  branch,
              sha:           commit.id,
              message:       commit.title,
              author:        commit.author_name,
              author_email:  commit.author_email,
              web_url:       "#{repo.html_url}/commits/#{commit.id}"
            )
          rescue RequestError
            nil
          end
        end

      end
    end
  end
end

