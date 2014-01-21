module Vx
  module ServiceConnector
    class GitlabV3
      DeployKeys = Struct.new(:session, :repo) do

        def add(key_name, public_key)
        end

        def remove(key_name)
        end
      end
    end
  end
end

