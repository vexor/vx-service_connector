require 'base64'

module Vx
  module ServiceConnector
    class Github
      Files = Struct.new(:session, :repo) do

        def get(sha, path)
          begin
            file = session.contents repo.full_name, ref: sha, path: path
            ::Base64.decode64 file.content
          rescue ::Exception => e
            $stderr.puts "ERROR: #{e.inspect}"
            nil
          end
        end

      end
    end
  end
end
