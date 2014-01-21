module GitlabV3Mocks

  def mock_add_deploy_key
    mock_post "http://example.com/api/v3/projects/1/keys", '{}'
  end

  def mock_deploy_keys
    mock_get "http://example.com/api/v3/projects/1/keys", 'deploy_keys'
  end

  def mock_repos
    mock_get "http://example.com/api/v3/projects", 'projects'
  end

  def mock_get(url, fixture)
    stub_request(:get, "#{url}?private_token=token").
      with(:headers => {'Accept'=>'application/json'}).
      to_return(
        :status => 200,
        :body => read_fixture("gitlab_v3/#{fixture}.json"),
        :headers => {'Content-Type' => 'application/json'})
  end

  def mock_post(url, body)
    stub_request(:post, "#{url}?private_token=token").
      with(:headers => {'Accept'=>'application/json'}, body: body).
      to_return(:status => 200, :body => "{}", :headers => {'Content-Type' => 'application/json'})
  end
end
