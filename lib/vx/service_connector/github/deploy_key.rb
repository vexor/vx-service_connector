module Vx
  module ServiceConnector
    class Github
      class DeployKey

        attr_reader :session

        def initialize(session)
          @session = session
        end

        def add(repo_full_name, key_name, public_key)
          session.add_deploy_key(
            repo_full_name,
            key_name,
            public_key
          )
        end

        def remove(repo_full_name, key_name)
          session.deploy_keys(repo_full_name).select do |key|
            key.title == key_name
          end.map do |key|
            session.remove_deploy_key(repo_full_name, key.id)
          end
        end

      end
    end
  end
end
