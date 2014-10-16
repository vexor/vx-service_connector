module Vx
  module ServiceConnector
    class Bitbucket
      Commits = Struct.new(:session, :repo) do
        def last(options = {})
          begin
            commit = session.get "#{BITBUCKET_API_1}/repositories/#{repo.full_name}/changesets/?limit=1"
            author, email = commit.author.raw.split('<')
            branch = commit.branch || 'master'
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