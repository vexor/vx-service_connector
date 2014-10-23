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
            'type' => 'POST',
            'URL'  => url
          )
          session.post(
            hooks_url,
            'type' => 'Pull Request POST',
            'URL'  => url,
            'create/edit/merge/decline' => 'on',
            'comments'                  => 'off',
            'approve/unapprove'         => 'off'
          )
        end

        def destroy(url_mask)
          all.select do |hook|
            url = extract_url(hook)
            url && url =~ /#{Regexp.escape url_mask}/
          end.map do |hook|
            session.delete hook_url(hook['id'])
          end
        end

        private

          def extract_url(hook)
            fields = hook['service']['fields']
            url = fields.select{|f| f['name'] == 'URL' }.map{|f| f['value'] }.first
            url
          end

          def hooks_url
            "api/1.0/repositories/#{repo.full_name}/services"
          end

          def hook_url(id)
            "#{hooks_url}/#{id}"
          end

      end
    end
  end
end
