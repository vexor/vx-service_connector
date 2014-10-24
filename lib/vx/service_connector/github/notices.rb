module Vx
  module ServiceConnector
    class Github
      Notices = Struct.new(:session, :repo) do

        def create(build_sha, build_status, build_url, description)
          if status = github_status(build_status)
            begin
              session.create_status(
                repo.full_name,
                build_sha,
                status,
                description: description,
                target_url:  build_url
              )
            rescue Octokit::UnprocessableEntity, Octokit::Unauthorized
            end
          end
        end

        private

          def github_status(build_status)
            case build_status.to_sym
            when :started
              'pending'
            when :passed
              'success'
            when :failed
              'failure'
            when :errored
              'error'
            end
          end

      end
    end
  end
end
