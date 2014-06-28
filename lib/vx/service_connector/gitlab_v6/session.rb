require 'sawyer'
require 'uri'

module Vx
  module ServiceConnector
    class GitlabV6
      Session = Struct.new(:endpoint, :private_token) do

        def get(url, options = {})
          wrap do
            res = agent.call :get, request_url(url), nil, query: options
            response! res
          end
        end

        def post(url, options = {})
          wrap do
            res = agent.call :post, request_url(url), options, nil
            response! res
          end
        end

        def delete(url, options = {})
          wrap do
            res = agent.call :delete, request_url(url), nil, query: options
            response! res
          end
        end

        def uri
          @uri ||= URI(endpoint)
        end

        private

          def wrap
            begin
              yield
            rescue Errno::ETIMEDOUT => e
              raise RequestError, e
            rescue Faraday::TimeoutError => e
              raise RequestError, e
            end
          end

          def response!(res)
            if (200..204).include?(res.status)
              res.data
            else
              raise RequestError, res.data.inspect
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
              http.ssl.verify               = false
              http.options[:timeout]        = 5
              http.options[:open_timeout]   = 5
            end
          end
      end

    end
  end
end
