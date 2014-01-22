module Vx
  module ServiceConnector
    module Model

      Repo = Struct.new(
        :id,
        :full_name,
        :is_private,
        :ssh_url,
        :html_url
      )

      Payload = Struct.new(
        :pull_request?,
        :pull_request_number,
        :head,
        :base,
        :branch,
        :branch_label,
        :url,
        :ignore?
      ) do
        def to_hash ; to_h end

        class << self
          def from_hash(params)
            payload = Payload.new
            payload.members.each do |m|
              payload[m] = params[m]
            end
            payload
          end
        end
      end

      Commit = Struct.new(
        :sha,
        :message,
        :author,
        :author_email,
        :http_url
      )

    end

  end
end
