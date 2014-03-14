module Vx
  module ServiceConnector
    class GitlabV6::Payload < GitlabV5::Payload

      private

        def pull_request?
          self["object_kind"] == "merge_request"
        end

        def tag?
          !pull_request? && self["ref"].start_with?("refs/tags/")
        end

        def pull_request_number
          if pull_request?
            pull_request["iid"]
          end
        end

        def pull_request_head_repo_id
          if pull_request?
            pull_request["source_project_id"]
          end
        end

        def web_url
          if pull_request?
            base_url = project_details["web_url"]
            id = pull_request["iid"]

            "#{base_url}/merge_requests/#{id}"

          elsif u = self["repository"] && self["repository"]["homepage"]
            "#{u}/commit/#{sha}"
          end
        end

        def pull_request_base_repo_id
          if pull_request?
            pull_request["target_project_id"]
          end
        end

        def sha
          if pull_request?
            commit_sha_for_pull_request
          else
            self["after"]
          end
        end

        def closed_pull_request?
          pull_request? && (%w(closed merged).include? pull_request["state"].to_s)
        end

        def pull_request
          if pull_request?
            self["object_attributes"]
          end
        end

        def project_details
          @project_details ||= begin
            project = session.get("/projects/#{repo.id}")
          rescue RequestError => e
            $stderr.puts "ERROR: #{e.inspect}"
            nil
          end
        end

        def commit_sha_for_pull_request
          @commit_sha ||= begin
            branch_details = session.get("/projects/#{repo.id}/repository/branches/#{branch}")
            branch_details["commit"]["id"]
          rescue RequestError => e
            $stderr.puts "ERROR: #{e.inspect}"
            nil
          end
        end

        def branch
          if pull_request?
            pull_request["source_branch"]
          else
            self["ref"].to_s.split("refs/heads/").last
          end
        end

        def commit_for_payload
          @commit_for_payload ||=
            begin
              commit = session.get(commit_uri(repo.id, sha))
            rescue RequestError => e
              $stderr.puts "ERROR: #{e.inspect}"
              {}
            end
        end

        def commit_uri(repo_id, sha)
          "/projects/#{repo_id}/repository/commits/#{sha}"
        end
    end
  end
end
