module Vx
  module ServiceConnector
    class Bitbucket
      DeployKeys = Struct.new(:session, :repo) do

        def all
          begin
            session.get "api/1.0/repositories/#{repo.full_name}/deploy-keys?pagelen=100"
          rescue RequestError
            []
          end
        end

        def create(key_name, public_key)
          session.post "api/1.0/repositories/#{repo.full_name}/deploy-keys", label: key_name, key: public_key
        end

        def destroy(key_name)
          all.select do |key|
            key['label'] == key_name
          end.map do |key|
            session.delete "api/1.0/repositories/#{repo.full_name}/deploy-keys/#{key['pk']}"
          end
        end

      end
    end
  end
end
