def create(name, params = {})
  case name
  when :repo
    Vx::ServiceConnector::Model::Repo.new(1, 'full/name', false, 'ssh@example.com', 'http://example.com')
  end
end
