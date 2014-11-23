require 'base64'

module Vx
  module ServiceConnector
    class Bitbucket
      Files = Struct.new(:session, :repo) do

        def get(sha, path)
          begin
            re = session.get("api/1.0/repositories/#{repo.full_name}/src/#{sha}/#{path}")
            # TODO: check and remove source
            re['source'] || re['data']
          rescue RequestError => e
            $stderr.puts "ERROR: #{e.inspect}"
            nil
          end
        end

      end
    end
  end
end
