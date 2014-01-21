module GitlabV3Mocks

  def mock_repos
    stub_request(:get, "http://example.com/api/v3/projects?private_token=token").
      with(:headers => {'Accept'=>'application/json'}).
      to_return(
        :status => 200,
        :body => read_fixture("gitlab_v3/projects.json"),
        :headers => {'Content-Type' => 'application/json'})
  end
end
