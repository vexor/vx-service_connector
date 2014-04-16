module Vx
  module ServiceConnector
    class GitlabV6::Hooks < GitlabV5::Hooks
      private
        def hook_url(id)
          "#{hooks_url}/#{id}"
        end
    end
  end
end

