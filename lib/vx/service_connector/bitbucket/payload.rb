module Vx
  module ServiceConnector
    class Bitbucket
      Payload = Struct.new(:session, :params) do

        def build
          ServiceConnector::Model::Payload.from_hash(
            internal_pull_request?: (pull_request? && !foreign_pull_request?),
            foreign_pull_request?:  foreign_pull_request?,
            pull_request_number:    pull_request_number,
            branch:                 branch,
            branch_label:           branch_label,
            sha:                    sha,
            message:                message,
            author:                 author,
            author_email:           author_email,
            web_url:                web_url,
            tag:                    tag_name,
            skip:                   ignore?,
          )
        end

        private

        # TODO: implement
        def tag_name
          nil
        end

        def pull_request?
          !(key? 'repository') && pull_request
        end

        def pull_request_number
          if pull_request? && pull_request.key?('id')
            pull_request['id']
          end
        end

        def sha
          if pull_request?
            pull_request['source']['commit']['hash']
          else
            head_commit['raw_node']
          end
        end

        def branch
          @branch ||= begin
            if pull_request?
              pull_request['source']['branch']['name']
            else
              head_commit['branch']
            end
          end
        end

        def branch_label
          branch
        end

        def web_url
          if pull_request?
            pull_request['links'] ? pull_request['links']['html']['href'] : nil
          elsif head_commit && params['repository']
            "https://bitbucket.org#{params['repository']['absolute_url']}commits/#{head_commit['raw_node']}"
          end
        end

        def message
          if pull_request?
            commit_for_pull_request["message"]
          else
            head_commit['message']
          end
        end

        def author
          if pull_request?
            commit_for_pull_request["author"]["user"]["display_name"]
          else
            head_commit['author']
          end
        end

        def commits?
          params['commits'] && !(params['commits'].empty?)
        end

        def author_email
          if pull_request?
            commit_for_pull_request["author"]["raw"][/.*<([^>]*)/,1]
          else
            commits? && head_commit['raw_author'][/.*<([^>]*)/,1]
          end
        end

        def closed_pull_request?
          %w(DECLINED MERGED).include?(pull_request_state)
        end

        def pull_request_state
          pull_request? and pull_request.is_a?(Hash) and pull_request['state']
        end

        def pull_request_head_repo_full_name
          pull_request['source']['repository']['full_name']
        end

        def pull_request_base_repo_full_name
          pull_request['destination']['repository']['full_name']
        end

        def foreign_pull_request?
          if pull_request?
            pull_request_head_repo_full_name != pull_request_base_repo_full_name
          end
        end

        def ignore?
          if pull_request?
            closed_pull_request?
          else
            sha == '0000000000000000000000000000000000000000' || !commits?
          end
        end

        def commit_for_pull_request
          @commit_for_pull_request ||= begin
            session.get pull_request['source']['commit']['links']['self']['href']
          end
        end

        def head_commit
          ( params['commits'] && params['commits'].last ) || {}
        end

        def pull_request
          @pull_request ||= begin
            params.first.last.is_a?(Hash) && params.first.last
          end
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
