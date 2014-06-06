module Vx
  module ServiceConnector
    class GitlabV6

      Payload = Struct.new(:session, :repo, :params) do

        def build
          ServiceConnector::Model::Payload.new(
            !!ignore?,
            !!pull_request?,
            pull_request_number,
            branch,
            branch_label,
            sha,
            message,
            author,
            author_email,
            web_url
          )
        end

        private

        def message
          commit_for_payload["title"]
        end

        def author
          commit_for_payload["author_name"]
        end

        def author_email
          commit_for_payload["author_email"]
        end

        def branch_label
          branch
        end

        def foreign_pull_request?
          pull_request_base_repo_id != pull_request_head_repo_id
        end

        def ignore?
          if pull_request?
            closed_pull_request? || !foreign_pull_request?
          else
            sha == '0000000000000000000000000000000000000000' || tag?
          end
        end

        def key?(name)
          params.key? name
        end

        def [](val)
          params[val]
        end

      #=== V6

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
          case
          when pull_request?
            base_url = project_details["web_url"]
            id = pull_request["iid"]
            "#{base_url}/merge_requests/#{id}"
          when self["repository"] && self["repository"]["homepage"]
            u = self["repository"]["homepage"]
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
            session.get("/projects/#{repo.id}")
          rescue RequestError => e
            $stderr.puts "ERROR: #{e.inspect}"
            nil
          end
        end

        def commit_sha_for_pull_request
          @commit_sha ||= begin
            if not ignore?
              branch_details = session.get("/projects/#{repo.id}/repository/branches/#{branch}")
              branch_details["commit"]["id"]
            else
              nil
            end
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
              if not ignore?
                session.get(commit_uri(repo.id, sha))
              else
                {}
              end
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
end
