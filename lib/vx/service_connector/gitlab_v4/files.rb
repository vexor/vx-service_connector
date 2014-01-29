require 'base64'

module Vx
  module ServiceConnector
    class GitlabV4
      Files = Struct.new(:session, :repo) do

        def get(sha, path)
          session.get("/projects/#{repo.id}/repository/commits/#{sha}/blob", filepath: path)
        end

      end
    end
  end
end
