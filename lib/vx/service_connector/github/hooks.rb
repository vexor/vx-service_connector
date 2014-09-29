module Vx
  module ServiceConnector
    class Github
      Hooks = Struct.new(:session, :repo) do

        def all
          begin
            session.hooks(repo.full_name)
          rescue Octokit::NotFound
            []
          end
        end

        def create(url, token)
          config = {
            url:           url,
            secret:        token,
            content_type: "json"
          }
          options = { events: %w{ push pull_request } }
          begin
            session.create_hook(repo.full_name, "web", config, options)
            true
          rescue ::Octokit::NotFound
            nil
          end
        end

        def destroy(url_mask)
          all.select do |hook|
            if url = hook.config.rels[:self]
              url.href =~ /#{Regexp.escape url_mask}/
            end
          end.map do |hook|
            session.remove_hook(repo.full_name, hook.id)
          end
        end

      end
    end
  end
end
