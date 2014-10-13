module Vx
  module ServiceConnector
    class Bitbucket
      Commits = Struct.new(:session, :repo) do
        def last(options = {})
          begin
            default_branch = session.get "https://bitbucket.org/api/1.0/repositories/#{repo.full_name}/main-branch"
            branch = default_branch.name || 'master'
            commit = session.get "https://bitbucket.org/api/2.0/repositories/#{repo.full_name}/commit/#{branch}"
            author, email = commit.author.raw.split('<')
            Model::Payload.from_hash(
              skip:          false,
              pull_request?: false,
              branch:        branch,
              branch_label:  branch,
              sha:           commit.hash,
              message:       commit.message,
              author:        author.strip,
              author_email:  email.tr('>',''),
              web_url:       commit.links.html.href
            )
          rescue RequestError
            nil
          end
        end
      end
    end
  end
end