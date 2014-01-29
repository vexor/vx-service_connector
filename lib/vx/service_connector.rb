require File.expand_path("../service_connector/version", __FILE__)
require File.expand_path("../service_connector/error",   __FILE__)

module Vx
  module ServiceConnector

    autoload :Base,      File.expand_path("../service_connector/base",       __FILE__)
    autoload :Github,    File.expand_path("../service_connector/github",     __FILE__)
    autoload :GitlabV4,  File.expand_path("../service_connector/gitlab_v4",  __FILE__)
    autoload :GitlabV5,  File.expand_path("../service_connector/gitlab_v5",  __FILE__)
    autoload :Model,     File.expand_path("../service_connector/model",      __FILE__)

    extend self

    def github ; Github end
    def gitlab_v3 ; GitlabV3 end

    def to(name)
      case name.to_sym
      when :github
        Github
      when :gitlab_v4
        GitlabV4
      when :gitlab_v5
        GitlabV5
      else
        raise ArgumentError, "Serivice for #{name.inspect} is not defined"
      end
    end

    def payload(name, params)
      klass =
        case name.to_sym
        when :github
          Github::Payload
        when :gitlab_v4, :gitlab_v5
          GitlabV4::Payload
        else
          raise ArgumentError, "Payload for #{name.inspect} is not defined"
        end
      klass.new(params).to_model
    end

  end
end
