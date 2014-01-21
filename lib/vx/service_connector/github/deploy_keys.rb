module Vx
  module ServiceConnector
    class Github
      DeployKeys = Struct.new(:session, :repo) do

        def all
          session.deploy_keys(repo.full_name)
        end

        def add(key_name, public_key)
          session.add_deploy_key(
            repo.full_name,
            key_name,
            public_key
          )
        end

        def remove(key_name)
          all.select do |key|
            key.title == key_name
          end.map do |key|
            session.remove_deploy_key(repo.full_name, key.id)
          end
        end

      end
    end
  end
end
