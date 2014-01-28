module Vx
  module ServiceConnector
    class GitlabV41
      DeployKeys = Struct.new(:session, :repo) do

        def all
          session.get "/user/keys"
        end

        def create(key_name, public_key)
          key_name = compute_key_name(key_name)
          session.post "/user/keys", title: key_name, key: public_key
        end

        def destroy(key_name)
          key_name = compute_key_name(key_name)
          all.select do |key|
            key.title == key_name
          end.map do |key|
            session.delete "/user/keys/#{key.id}"
          end
        end

        private
          def compute_key_name(orig_name)
            "(#{repo.full_name}) #{orig_name}"
          end
      end
    end
  end
end

