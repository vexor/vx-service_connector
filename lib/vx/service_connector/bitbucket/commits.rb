module Vx
  module ServiceConnector
    class Bitbucket
      Commits = Struct.new(:session, :repo) do
        def last(options = {})
          begin
            commits = session.get "api/1.0/repositories/#{repo.full_name}/changesets/?limit=1"
            commit  = commits["changesets"].first
            author, email = commit["raw_author"].split(/[<>]/)
            sha = commit["raw_node"]
            branch = commit["branch"] || 'master'
            Model::Payload.from_hash(
              skip:          false,
              pull_request?: false,
              branch:        branch,
              branch_label:  branch,
              sha:           sha,
              message:       commit["message"],
              author:        author.strip,
              author_email:  email,
              web_url:       session.endpoint.to_s + "/#{repo.full_name}/commits/#{sha}"
            )
          rescue RequestError
            nil
          end
        end
      end
    end
  end
end
