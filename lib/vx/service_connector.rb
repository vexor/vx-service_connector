require File.expand_path("../service_connector/version", __FILE__)

module Vx
  module ServiceConnector
    autoload :Github,   File.expand_path("../service_connector/github",    __FILE__)
    autoload :GitlabV3, File.expand_path("../service_connector/gitlab_v3", __FILE__)
    autoload :Model,    File.expand_path("../service_connector/model",     __FILE__)

    module Mixin
      autoload :StatusDescription,  File.expand_path("../service_connector/mixin/status_description", __FILE__)
    end
  end
end
