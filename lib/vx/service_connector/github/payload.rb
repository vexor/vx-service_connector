require 'ostruct'

module Vx
  module ServiceConnector
    class Github
      Payload = Struct.new(:session, :params) do

        def build
          ServiceConnector::Model::Payload.new(
            !!ignore?,
            !!pull_request,
            pull_request_number,
            branch,
            branch_label,
            sha,
            message,
            author,
            author_email,
            author_avatar_url,
            web_url
          )
        end

        private

        def pull_request?
          key? "pull_request"
        end

        def tag?
          !pull_request? && self['ref'] =~ /^#{Regexp.escape 'refs/tags/'}/
        end

        def author_avatar_url
          if pull_request?
            pull_request['head']['user']['avatar_url']
          else
            ServiceConnector::Model::DEFAULT_AVATAR_URL
          end
        end

        def pull_request_number
          if pull_request? && key?("number")
            self["number"]
          end
        end

        def sha
          if pull_request?
            pull_request["head"]["sha"]
          else
            self["after"]
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

        def web_url
          if pull_request?
            pull_request["html_url"]
          else
            head_commit["url"]
          end
        end

        def message
          if pull_request?
            commit_for_pull_request.message
          else
            head_commit["message"]
          end
        end

        def author
          if pull_request?
            commit_for_pull_request.author.name
          else
            head_commit? && head_commit["author"]["name"]
          end
        end

        def author_email
          if pull_request?
            commit_for_pull_request.author.email
          else
            head_commit? && head_commit["author"]["email"]
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
            sha == '0000000000000000000000000000000000000000' || tag?
          end
        end


        def commit_for_pull_request
          @commit_for_pull_request ||=
            begin
              data = session.commit pull_request["base"]["repo"]["full_name"], sha
              data.commit
            rescue ::Octokit::NotFound => e
              $stderr.puts "ERROR: #{e.inspect}"
              OpenStruct.new
            end
        end

        def head_commit?
          self["head_commit"]
        end

        def head_commit
          self["head_commit"] || {}
        end

        def pull_request
          self["pull_request"]
        end

        def key?(name)
          params.key? name
        end

        def [](val)
          params[val]
        end

      end

    end
  end
end
