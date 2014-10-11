module Vx
  module ServiceConnector
    class Bitbucket
      DeployKeys = Struct.new(:session, :repo) do

        def all
          ###
        end

        def create(key_name, public_key)
          ###
        end

        def destroy(key_name)
          ###
        end

      end
    end
  end
end