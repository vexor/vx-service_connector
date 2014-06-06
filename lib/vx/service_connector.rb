
require File.expand_path("../service_connector/version", __FILE__)
require File.expand_path("../service_connector/error",   __FILE__)

module Vx
  module ServiceConnector

    autoload :Base,       File.expand_path("../service_connector/base",       __FILE__)
    autoload :Github,     File.expand_path("../service_connector/github",     __FILE__)
    autoload :GitlabV5,   File.expand_path("../service_connector/gitlab_v5",  __FILE__)
    autoload :GitlabV6,   File.expand_path("../service_connector/gitlab_v6",  __FILE__)
    autoload :Model,      File.expand_path("../service_connector/model",      __FILE__)

    extend self

    def to(name)
      case name.to_sym
      when :github
        Github
      when :gitlab_v6
        GitlabV6
      else
        raise ArgumentError, "Serivice for #{name.inspect} is not defined"
      end
    end

  end
end

require File.expand_path("../service_connector/instrumentation", __FILE__)
