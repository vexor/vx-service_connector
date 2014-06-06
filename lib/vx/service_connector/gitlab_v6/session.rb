require 'sawyer'
require 'uri'

module Vx
  module ServiceConnector
    class GitlabV6
      Session = Struct.new(:endpoint, :private_token) do

        def get(url, options = {})
          res = agent.call :get, request_url(url), nil, query: options
          response! res
        end

        def post(url, options = {})
          res = agent.call :post, request_url(url), options, nil
          response! res
        end

        def delete(url, options = {})
          res = agent.call :delete, request_url(url), nil, query: options
          response! res
        end

        def uri
          @uri ||= URI(endpoint)
        end

        private

          def response!(res)
            if (200..204).include?(res.status)
              res.data
            else
              raise RequestError, res.data
            end
          end

          def request_url(url)
            "/api/v3/#{url}"
          end

          def api_endpoint
            "#{endpoint}/api/v3"
          end

          def agent
            @agent ||= Sawyer::Agent.new(api_endpoint) do |http|
              http.headers['content-type']  = 'application/json'
              http.headers['accept']        = 'application/json'
              http.headers['PRIVATE-TOKEN'] = private_token
            end
          end
      end

    end
  end
end
