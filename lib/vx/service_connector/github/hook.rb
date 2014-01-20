module Vx
  module ServiceConnector
    class Github
      class Hook

        attr_reader :session

        def initialize(session)
          @session = session
        end

        def add(repo_full_name, url, token)
          config = {
            url:           url,
            secret:        token,
            content_type: "json"
          }
          options = { events: %w{ push pull_request } }
          session.create_hook(repo_full_name, "web", config, options)
        end

        def remove(repo_full_name, url_mask)
          session.hooks(repo_full_name).select do |hook|
            if url = hook.config.rels[:self]
              url.href =~ /#{Regexp.escape url_mask}\//
            end
          end.map do |hook|
            session.remove_hook(repo_full_name, hook.id)
          end
        end

      end
    end
  end
end
