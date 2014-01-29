module GitlabV5WebMocks
  def mock_deploy_keys
    mock_get "projects/1/keys", "deploy_keys"
  end

  def mock_add_deploy_key
    mock_post "projects/1/keys", "{\"title\":\"me@example.com\",\"key\":\"public key\"}"
  end

  def mock_delete_deploy_key
    mock_delete "projects/1/keys/3", nil
  end

  def mock_get(url, fixture)
    stub_request(:get, "http://example.com/api/v3/#{url}").
      with(:headers => {'Accept'=>'application/json', 'PRIVATE-TOKEN' => "token"}).
      to_return(
        :status => 200,
        :body => read_fixture("gitlab_v5/#{fixture}.json"),
        :headers => {'Content-Type' => 'application/json'})
  end

  def mock_post(url, body)
    stub_request(:post, "http://example.com/api/v3/#{url}").
      with(:headers => {'Accept'=>'application/json', }, body: body).
      to_return(:status => 200, :body => "{}", :headers => {'Content-Type' => 'application/json'})
  end

  def mock_delete(url, body)
    stub_request(:delete, "http://example.com/api/v3/#{url}").
      with(:headers => {'Accept'=>'application/json', }, body: body).
      to_return(:status => 200, :body => "{}", :headers => {'Content-Type' => 'application/json'})
  end
end
