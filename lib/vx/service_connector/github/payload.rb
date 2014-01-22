module Vx
  module ServiceConnector
    class Github
      class Payload

        def initialize(params)
          @params = params || {}
        end

        def pull_request?
          key? "pull_request"
        end

        def tag?
          !pull_request? && self['ref'] =~ /^#{Regexp.escape 'refs/tags/'}/
        end

        def pull_request_number
          if pull_request? && key?("number")
            self["number"]
          end
        end

        def head
          if pull_request?
            pull_request["head"]["sha"]
          else
            self["after"]
          end
        end

        def base
          if pull_request?
            pull_request["base"]["sha"]
          else
            self["before"]
          end
        end

        def branch
          if pull_request?
            pull_request["head"]["ref"]
          else
            self["ref"].to_s.split("refs/heads/").last
          end
        end

        def branch_label
          if pull_request?
            pull_request["head"]["label"]
          else
            branch
          end
        end

        def url
          if pull_request?
            pull_request["url"]
          else
            self["compare"]
          end
        end

        def pull_request_head_repo_id
          if pull_request?
            pull_request['head']['repo']['id']
          end
        end

        def pull_request_base_repo_id
          if pull_request?
            pull_request['base']['repo']['id']
          end
        end

        def closed_pull_request?
          pull_request? && (pull_request["state"] == 'closed')
        end

        def foreign_pull_request?
          pull_request? && (pull_request_head_repo_id != pull_request_base_repo_id)
        end

        def ignore?
          if pull_request?
            closed_pull_request? || !foreign_pull_request?
          else
            head == '0000000000000000000000000000000000000000' ||
              tag?
          end
        end

        def to_model
          ServiceConnector::Model::Payload.new(
            !!pull_request,
            pull_request_number,
            head,
            base,
            branch,
            branch_label,
            url,
            !!ignore?
          )
        end

        private

          def pull_request
            self["pull_request"]
          end

          def key?(name)
            @params.key? name
          end

          def [](val)
            @params[val]
          end

      end

    end
  end
end
