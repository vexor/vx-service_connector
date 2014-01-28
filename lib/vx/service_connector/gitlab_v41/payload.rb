module Vx
  module ServiceConnector
    class GitlabV41
      class Payload

        def initialize(params)
          @params = params || {}
        end

        def pull_request?
          false
        end

        def tag?
          false
        end

        def pull_request_number
          nil
        end

        def head
          self["after"]
        end

        def base
          self["before"]
        end

        def branch
          self["ref"].to_s.split("refs/heads/").last
        end

        def branch_label
          branch
        end

        def url
          self["commits"] && self["commits"].first && self["commits"].first["url"]
        end

        def pull_request_head_repo_id
          nil
        end

        def pull_request_base_repo_id
          nil
        end

        def closed_pull_request?
          false
        end

        def foreign_pull_request?
          false
        end

        def ignore?
          head == '0000000000000000000000000000000000000000'
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
