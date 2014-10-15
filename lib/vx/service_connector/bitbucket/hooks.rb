module Vx
  module ServiceConnector
    class Bitbucket
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
            :type => 'POST',
            'URL' => url
          )
        end

        def destroy(url_mask)
          all.select do |hook|
            hook.service.fields.first.value =~ /#{Regexp.escape url_mask}/
          end.map do |hook|
            session.delete hook_url(hook.id)
          end
        end

        private

          def hooks_url
            "https://bitbucket.org/api/1.0/repositories/#{repo.full_name}/services"
          end

          def hook_url(id)
            "#{hooks_url}/#{id}"
          end

      end
    end
  end
end