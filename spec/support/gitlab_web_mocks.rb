module GitlabWebMocks

  def mock_repos
    mock_get "projects?per_page=30", 'projects'
  end

  def mock_repo
    mock_get "projects/1", 'project'
  end

  def mock_deploy_keys
    mock_get "projects/1/keys", 'deploy_keys'
  end

  def mock_add_deploy_key
    mock_post "projects/1/keys", '{"title":"me@example.com","key":"public key"}'
  end

  def mock_delete_deploy_key
    mock_delete "projects/1/keys/3", nil
  end

  def mock_add_hook
    mock_post "projects/1/hooks", "{\"url\":\"url\",\"push_events\":true,\"merge_requests_events\":true}"
  end

  def mock_hooks
    mock_get "projects/1/hooks", 'hooks'
  end

  def mock_get_file
    stub_request(:get, "http://example.com/api/v3/projects/1/repository/commits/sha/blob?filepath=path").
      with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json', 'Private-Token'=>'token'}).
      to_return(:status => 200, :body => "content")
  end

  def mock_get_file_not_found
    stub_request(:get, "http://example.com/api/v3/projects/1/repository/commits/sha/blob?filepath=path").
      with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json', 'Private-Token'=>'token'}).
      to_return(:status => 404, :body => "")
  end

  def mock_get_commit_not_found
    stub_request(:get, "http://example.com/api/v3/projects/1/repository/commits?ref_name=sha").
      with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json', 'Private-Token'=>'token'}).
      to_return(:status => 404, :body => "")
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
