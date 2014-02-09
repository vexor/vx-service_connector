module Vx
  module ServiceConnector
    class Github
      DeployKeys = Struct.new(:session, :repo) do

        def all
          begin
            session.deploy_keys(repo.full_name)
          rescue Octokit::NotFound
            []
          end
        end

        def create(key_name, public_key)
          session.add_deploy_key(
            repo.full_name,
            key_name,
            public_key
          )
        end

        def destroy(key_name)
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
