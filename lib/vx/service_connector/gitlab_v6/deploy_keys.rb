module Vx
  module ServiceConnector
    class GitlabV6
      DeployKeys = Struct.new(:session, :repo) do

        def all
          begin
            session.get "/projects/#{repo.id}/keys"
          rescue RequestError
            []
          end
        end

        def create(key_name, public_key)
          session.post "/projects/#{repo.id}/keys", title: key_name, key: public_key
        end

        def destroy(key_name)
          all.select do |key|
            key.title == key_name
          end.map do |key|
            session.delete "/projects/#{repo.id}/keys/#{key.id}"
          end
        end

      end
    end
  end
end

