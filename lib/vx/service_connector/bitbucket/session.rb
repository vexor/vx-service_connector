require 'oauth'
require 'json'
require 'ostruct'
require 'uri'

module Vx
  module ServiceConnector
    class Bitbucket
      Session = Struct.new(:login, :options) do

        def get(url)
          wrap do
            res = agent.get request_url(url)
            response! res
          end
        end

        def post(url, options = {})
          wrap do
            res = agent.post request_url(url), options
            response! res
          end
        end

        def delete(url)
          wrap do
            res = agent.delete request_url(url)
            response! res
          end
        end

        def endpoint
          @endpoint ||= URI("https://bitbucket.org")
        end

        def self.test
          {
            consumer_key:    "key",
            consumer_secret: "secret",
            token:           "token",
            token_secret:    "token secret"
          }
        end

        private


          def request_url(url)
            if url.include?(endpoint.to_s)
              url
            else
              "#{endpoint}/#{url}"
            end
          end

          def response!(res)
            if (200..204).include?(res.code.to_i)
              if res.header['Content-Type'].to_s.include?("application/json")
                ::JSON.parse(res.body)
              else
                res.body
              end
            else
              raise RequestError, res.body
            end
          end

          def wrap
            begin
              yield
            rescue Errno::ETIMEDOUT => e
              raise RequestError, e
            end
          end

          def validate_options!
            unless options.is_a?(Hash) && options.keys.sort == [:consumer_key, :consumer_secret, :token, :token_secret]
              raise InvalidArguments, options
            end
          end

          def agent
            @agent ||= begin
              validate_options!
              consumer = OAuth::Consumer.new(
                options[:consumer_key], options[:consumer_secret],
                site: endpoint.to_s
              )
              token = OAuth::AccessToken.new consumer, options[:token], options[:token_secret]
=begin
              Sawyer::Agent.new(endpoint) do |http|
                http.headers['content-type']  = 'application/json'
                http.headers['accept']        = 'application/json'
                http.ssl.verify               = false
                http.options[:timeout]        = 5
                http.options[:open_timeout]   = 5
                http.request :oauth,
                  consumer_key:    "7j4RYZEd8YTQdfTWkJ",
                  consumer_secret: "Y8fSdaDK4GxKzvJn3tKRzyyYXctYSbUV",
                  token:           "WhFvryHuZ82XLKW6aP",
                  token_secret:    "zLSQe2DwhA4mfzwnPA53pKqLSyZgX5XH"
                  ignore_extra_keys: true
                http.response :logger
              end
=end
              token
            end
          end

      end
    end
  end
end
