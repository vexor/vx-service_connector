module Vx
  module ServiceConnector
    class GitlabV3
      DeployKeys = Struct.new(:session, :repo) do

        def all
          session.deploy_keys(repo.id)
        end

        def add(key_name, public_key)
          session.create_deploy_key(repo.id, key_name, public_key)
        end

        def remove(key_name)
        end
      end
    end
  end
end

