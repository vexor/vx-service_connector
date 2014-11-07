module Vx
  module ServiceConnector
    module Model

      PAYLOAD_IGNORE_RE = Regexp.escape("[ci skip]")

      Repo = Struct.new(
        :id,
        :full_name,
        :is_private,
        :ssh_url,
        :html_url,
        :description,
        :language
      )

      Payload = Struct.new(
        :internal_pull_request?,
        :foreign_pull_request?,
        :pull_request_number,
        :branch,
        :branch_label,
        :sha,
        :message,
        :author,
        :author_email,
        :web_url,
        :skip,
        :tag,
      ) do
        def to_hash ; to_h end

        def perform?(options = {})
          return false if ignore?

          case
          when options.empty? # default
            if internal_pull_request?
              false
            else
              true
            end
          when options[:branch
          end
        end

        def ignore?
          !!(skip || message.to_s =~ /#{PAYLOAD_IGNORE_RE}/)
        end

        def tag?
          !!tag
        end

        def pull_request?
          internal_pull_request? or foreign_pull_request?
        end

        class << self
          def from_hash(params)
            payload = Payload.new
            payload.members.each do |m|
              payload[m] = params.key?(m) ? params[m] : params[m.to_s]
            end
            payload
          end
        end
      end

      extend self

      def test_payload_attributes(params = {})
        {
          skip:                   false,
          foreign_pull_request?:  false,
          internal_pull_request?: false,
          pull_request_number:    nil,
          branch:                 'master',
          branch_label:           'master:label',
          sha:                    "HEAD",
          message:                'test commit',
          author:                 'User Name',
          author_email:           'me@example.com',
          web_url:                'http://example.com',
          tag:                    nil
        }.merge(params)
      end

      def test_payload(params = {})
        Payload.from_hash(test_payload_attributes params)
      end

      def test_repo
        Repo.new(
          1,
          'full/name',
          false,
          'git@example.com',
          'http://example.com',
          'description'
        )
      end

    end

  end
end
