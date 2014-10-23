require 'base64'

module Vx
  module ServiceConnector
    class Bitbucket
      Files = Struct.new(:session, :repo) do

        def get(sha, path)
          begin
            re = session.get("api/1.0/repositories/#{repo.full_name}/src/#{sha}/#{path}")
            re['source']
          rescue RequestError => e
            $stderr.puts "ERROR: #{e.inspect}"
            nil
          end
        end

      end
    end
  end
end
