module Vx
  module ServiceConnector
    class GitlabV6 < GitlabV5
    end
  end
end

Dir[File.expand_path("../gitlab_v6/*.rb", __FILE__)].each do |f|
  require f
end
