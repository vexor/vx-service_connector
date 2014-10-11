require 'sawyer'
require 'uri'

module Vx
  module ServiceConnector
    class Bitbucket
      Session = Struct.new(:endpoint, :private_token) do

        def get(url, options = {})
          ###
        end

        def post(url, options = {})
          ###
        end

        def delete(url, options = {})
          ###
        end

        def uri
          ###
        end
          
      end
    end
  end
end