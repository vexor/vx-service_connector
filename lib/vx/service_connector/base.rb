module Vx
  module ServiceConnector
    module Base

      def repos
        raise ArgumentError, 'not implemented'
      end

      def organizations
        raise ArgumentError, 'not implemented'
      end

      def deploy_keys(repo)
        raise ArgumentError, 'not implemented'
      end

      def hooks(repo)
        raise ArgumentError, 'not implemented'
      end

      def notices(repo)
        raise ArgumentError, 'not implemented'
      end

      def session
        @session ||= create_session
      end

    end
  end
end
