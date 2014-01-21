require File.expand_path("../service_connector/version", __FILE__)

module Vx
  module ServiceConnector

    autoload :Base,     File.expand_path("../service_connector/base",      __FILE__)
    autoload :Github,   File.expand_path("../service_connector/github",    __FILE__)
    autoload :GitlabV3, File.expand_path("../service_connector/gitlab_v3", __FILE__)
    autoload :Model,    File.expand_path("../service_connector/model",     __FILE__)

  end
end
