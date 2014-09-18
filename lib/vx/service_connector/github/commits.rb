require 'base64'

module Vx
  module ServiceConnector
    class Github
      Commits = Struct.new(:session, :repo) do
        def last(options = {})
          begin
            commit = session.commit(repo.full_name, 'HEAD')
            Model::Payload.from_hash(
              skip:          false,
              pull_request?: false,
              branch:        'HEAD',
              branch_label:  'HEAD',
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
