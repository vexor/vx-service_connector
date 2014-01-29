module Vx
  module ServiceConnector
    class GitlabV5
      class Payload

        def initialize(params)
          @params = params || {}
        end

        def pull_request?
          self["object_kind"] == 'merge_request'
        end

        def tag?
          false
        end

        def pull_request_number
          if pull_request?
            pull_request["id"]
          end
        end

        def head
          if pull_request?
            cid = (pull_request["st_commits"] || []).first
            cid && cid["id"]
          else
            self["after"]
          end
        end

        def base
          if pull_request?
            cid = (pull_request["st_commits"] || []).first
            cid && cid["parent_ids"] && cid["parent_ids"].first
          else
            self["before"]
          end
        end

        def branch
          if pull_request?
            pull_request["source_branch"]
          else
            self["ref"].to_s.split("refs/heads/").last
          end
        end

        def branch_label
          branch
        end

        def url
          self["commits"] && self["commits"].first && self["commits"].first["url"]
        end

        def pull_request_head_repo_id
          if pull_request?
            pull_request["target_project_id"]
          end
        end

        def pull_request_base_repo_id
          if pull_request?
            pull_request["source_project_id"]
          end
        end

        def closed_pull_request?
          false
        end

        def foreign_pull_request?
          pull_request_base_repo_id != pull_request_head_repo_id
        end

        def pull_request_status
          if pull_request?
            pull_request["merge_status"]
          end
        end

        def ignore_pull_request?
          if pull_request?
            pull_request_status != 'unchecked'
          end
        end

        def ignore?
          head == '0000000000000000000000000000000000000000' ||
            ignore_pull_request?
        end

        def to_model
          ServiceConnector::Model::Payload.new(
            !!pull_request?,
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
            self["object_attributes"] || {}
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
