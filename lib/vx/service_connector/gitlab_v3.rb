require 'gitlab'

module Vx
  module ServiceConnector
    GitlabV3 = Struct.new(:endpoint, :private_token) do

      include ServiceConnector::Base

      def repos
        @repos ||= GitlabV3::Repos.new(session).to_a
      end

      private

        def create_session
          ::Gitlab.client(:endpoint => "#{endpoint}/api/v3", private_token: private_token)
        end

    end
  end
end

%w{ repos deploy_keys }.each do |f|
  require File.expand_path("../gitlab_v3/#{f}", __FILE__)
end
