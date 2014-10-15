module Vx
  module ServiceConnector
    class Bitbucket
      Payload = Struct.new(:session, :params) do

        def build
          :not_available
        end

      end
    end
  end
end
