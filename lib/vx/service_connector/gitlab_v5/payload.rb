module Vx
  module ServiceConnector
    class GitlabV5
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

        def pull_request?
          false
        end

        def tag?
          false
        end

        def pull_request_number
          nil
        end

        def sha
          self["after"]
        end

        def branch
          self["ref"].to_s.split("refs/heads/").last
        end

        def branch_label
          branch
        end

        def web_url
          if u = self["repository"] && self["repository"]["homepage"]
            "#{u}/commit/#{sha}"
          end
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
          pull_request_base_repo_id != pull_request_head_repo_id
        end

        def ignore?
          if pull_request?
            closed_pull_request? || !foreign_pull_request?
          else
            sha == '0000000000000000000000000000000000000000' || tag?
          end
        end

        def pull_request
          {}
        end

        def key?(name)
          params.key? name
        end

        def [](val)
          params[val]
        end

        def commit_for_payload
          @commit_for_payload ||=
            begin
              commits = session.get(commit_uri(repo.id, sha))
              commits.first || {}
            rescue RequestError => e
              $stderr.puts "ERROR: #{e.inspect}"
              {}
            end
        end

        def commit_uri(repo_id, sha)
          "/projects/#{repo_id}/repository/commits?ref_name=#{sha}"
        end

      end

    end
  end
end
