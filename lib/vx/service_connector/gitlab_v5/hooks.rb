module Vx
  module ServiceConnector
    class GitlabV5
      Hooks = Struct.new(:session, :repo) do

        def all
          begin
            session.get hooks_url
          rescue RequestError
            []
          end
        end

        def create(url, token)
          session.post(
            hooks_url,
            url: url,
            push_events: true,
            merge_requests_events: true
          )
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

