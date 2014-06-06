module Vx
  module ServiceConnector
    class GitlabV6
      Files = Struct.new(:session, :repo) do

        def get(sha, path)
          begin
            session.get("/projects/#{repo.id}/repository/commits/#{sha}/blob", filepath: path)
          rescue RequestError => e
            $stderr.puts "ERROR: #{e.inspect}"
            nil
          end
        end

      end
    end
  end
end
