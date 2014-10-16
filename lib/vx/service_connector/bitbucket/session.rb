require 'sawyer'

module Vx
  module ServiceConnector
    class Bitbucket
      Session = Struct.new(:login, :private_token) do

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

        private

          def request_url(url)
            if url.include? 'api/1.0'
              "https://bitbucket.org/#{url}"
            else
              url
            end
          end

          def response!(res)
            if (200..204).include?(res.status)
              res.data
            else
              raise RequestError, res.data.inspect
            end
          end

          def wrap
            begin
              yield
            rescue Errno::ETIMEDOUT => e
              raise RequestError, e
            rescue Faraday::TimeoutError => e
              raise RequestError, e
            end
          end

          def agent
            @agent ||= Sawyer::Agent.new(login) do |http|
              http.headers['content-type']  = 'application/json'
              http.headers['accept']        = 'application/json'
              http.headers['Authorization'] = private_token
              http.ssl.verify               = false
              http.options[:timeout]        = 5
              http.options[:open_timeout]   = 5
            end
          end

      end
    end
  end
end