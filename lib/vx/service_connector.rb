require File.expand_path("../service_connector/version", __FILE__)
require File.expand_path("../service_connector/error",   __FILE__)

module Vx
  module ServiceConnector

    autoload :Base,      File.expand_path("../service_connector/base",       __FILE__)
    autoload :Github,    File.expand_path("../service_connector/github",     __FILE__)
    autoload :GitlabV4,  File.expand_path("../service_connector/gitlab_v4",  __FILE__)
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
      else
        raise ArgumentError, "Serivice for #{name.inspect} is not defined"
      end
    end

    def payload(name, params)
      case name.to_sym
      when :github
        Github::Payload.new(params).to_model
      else
        raise ArgumentError, "Payload for #{name.inspect} is not defined"
      end
    end

  end
end
