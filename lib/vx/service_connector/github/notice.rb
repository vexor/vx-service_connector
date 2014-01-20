module Vx
  module ServiceConnector
    class Github
      class Notice

        attr_reader :session

        def initialize(session)
          @session = session
        end

        def create(repo_full_name, build_sha, build_status, build_url, description)
          if status = github_status(build_status)
            begin
              session.create_status(
                repo_full_name,
                build_sha,
                status,
                description: description,
                target_url:  build_url
              )
            rescue Octokit::UnprocessableEntity => e
              STDERR.puts "ERROR: #{e.inspect}"
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
