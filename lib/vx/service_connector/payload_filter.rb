module Vx
  module ServiceConnector
    class PayloadFilter

      attr_reader :payload, :options

      def initialize(payload, options = {})
        @payload = payload
        @options = options
      end

      def perform?
        return false if payload.ignore?

        if options.empty?
          not (
            payload.internal_pull_request? ||
            payload.tag?
          )
        end
      end

      def pull_request?
        options[:pull_request] and payload.pull_request?
      end

      def tag?
        options[:tag] and payload.tag?
      end

      def branch?
        @branch ||= Array(options[:branch]).map do |branch_name|
          branch_name = branch_name.to_s
          if branch_name[0] == "/" && branch_name[-1] == "/"
            begin
              Regexp.new(branch_name).match?(payload.branch)
            rescue RegexpError
              false
            end
          else
            branch_name == payload.branch
          end
        end.any?
      end

    end
  end
end
