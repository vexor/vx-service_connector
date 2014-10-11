require 'base64'

module Vx
  module ServiceConnector
    class Bitbucket
      Files = Struct.new(:session, :repo) do

        def get(sha, path)
          ###
        end

      end
    end
  end
end