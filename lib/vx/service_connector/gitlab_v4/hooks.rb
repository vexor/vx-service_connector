module Vx
  module ServiceConnector
    class GitlabV4
      Hooks = Struct.new(:session, :repo) do

        def all
          session.get hooks_url
        end

        def create(url, token)
          session.post hooks_url, url: url
        end

        def destroy(url_mask)
          all.select do |hook|
            hook.url =~ /#{Regexp.escape url_mask}/
          end.map do |hook|
            session.delete hooks_url, hook_id: hook.id
          end
        end

        private

          def hooks_url
            "/projects/#{repo.id}/hooks"
          end

      end
    end
  end
end

