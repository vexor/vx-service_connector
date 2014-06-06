module Vx
  module ServiceConnector
    class GitlabV6
      Notices = Struct.new(:session, :repo) do
        def create(build_sha, build_status, build_url, description)
          :not_available
        end
      end
    end
  end
end
