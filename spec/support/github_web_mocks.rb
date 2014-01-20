module GithubWebMocks

  def mock_remove_hook
    mock_delete  "https://api.github.com/repos/test/hooks/1", "{}"
  end

  def mock_hooks
    mock_get "https://api.github.com/repos/test/hooks?per_page=100",
             "hooks"
  end

  def mock_add_hook
    mock_post "https://api.github.com/repos/test/hooks",
              "{\"name\":\"web\",\"config\":{\"url\":\"url\",\"secret\":\"token\",\"content_type\":\"json\"},\"events\":[\"push\",\"pull_request\"],\"active\":true}",
              "create_hook"
  end

  def mock_deploy_keys
    mock_get "https://api.github.com/repos/test/keys?per_page=100", "deploy_keys"
  end

  def mock_delete_deploy_key
    mock_delete "https://api.github.com/repos/test/keys/1", "{}"
  end

  def mock_add_deploy_key
    mock_post "https://api.github.com/repos/test/keys",
              "{\"title\":\"octocat@octomac\",\"key\":\"public key\"}",
              "add_deploy_key"
  end

  def mock_user_repos
    mock_get "https://api.github.com/user/repos?per_page=100", "user_repos"
  end

  def mock_org_repos
    mock_get "https://api.github.com/orgs/github/repos?per_page=100", "org_repos"
  end

  def mock_orgs
    mock_get "https://api.github.com/user/orgs", "orgs"
  end

  def mock_post(url, body, fixture)
    stub_request(:post, url).
      with(:body    => body,
           :headers => {
            'Accept'=>'application/vnd.github.beta+json',
            'Authorization'=>'token token'}).
      to_return(:status => 200, :body => read_fixture("github/#{fixture}.json"), :headers => {})
  end

  def mock_get(url, fixture)
    stub_request(:get, url).
      with(:headers => {
        'Accept'=>'application/vnd.github.beta+json',
        'Authorization'=>'token token'}).
      to_return(
        :status => 200,
        :body => read_fixture("github/#{fixture}.json"),
        :headers => {'Content-Type'=>"application/json"})
  end

  def mock_delete(url, body)
    stub_request(:delete, url).
      with(:body => body,
           :headers => {'Accept'=>'application/vnd.github.beta+json', 'Authorization'=>'token token'}).
      to_return(:status => 200, :body => "")
  end
end
