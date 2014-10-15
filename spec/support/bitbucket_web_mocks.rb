module BitbucketWebMocks

  def mock_get_commit(repo_name, sha)
    mock_get "https://bitbucket.org/api/2.0/repositories/#{repo_name}/commit/#{sha}", 'commit'
  end

  def mock_repo
    mock_get 'https://bitbucket.org/api/2.0/repositories/full/name', 'user_repo'
  end

  def mock_default_branch
    mock_get 'https://bitbucket.org/api/1.0/repositories/full/name/main-branch', 'default_branch'
  end

  def mock_user_repos
    mock_get "https://bitbucket.org/api/1.0/user/repositories?pagelen=100", "user_repos"
  end

  def mock_team_repos
    mock_get "https://bitbucket.org/api/2.0/repositories/team?pagelen=100", "team_repos"
  end

  def mock_teams
    mock_get "https://bitbucket.org/api/1.0/user/privileges", "teams"
  end

  def mock_deploy_keys
    mock_get "https://bitbucket.org/api/1.0/repositories/full/name/deploy-keys?pagelen=100",
             "deploy_keys"
  end

  def mock_delete_deploy_key
    mock_delete "https://bitbucket.org/api/1.0/repositories/full/name/deploy-keys/1", ""
  end

  def mock_add_deploy_key
    mock_post "https://bitbucket.org/api/1.0/repositories/full/name/deploy-keys",
              "{\"label\":\"octocat@octomac\",\"key\":\"public key\"}",
              "add_deploy_key"
  end

  def mock_add_hook
    mock_post "https://bitbucket.org/api/1.0/repositories/full/name/services",
              "{\"type\":\"POST\",\"url\":\"https://example.com\"}", ''
  end

  def mock_hooks
    mock_get 'https://bitbucket.org/api/1.0/repositories/full/name/services',
             'hooks'
  end

  def mock_remove_hook
    mock_delete  "https://api.github.com/repos/full/name/hooks/1", "{}"
  end

  def mock_get(url, fixture)
    stub_request(:get, url).
      with(:headers => {'Accept'=>'application/json', 'Authorization' => "token"}).
      to_return(
        :status => 200,
        :body => read_fixture("bitbucket/#{fixture}.json"),
        :headers => {'Content-Type' => 'application/json'})
  end

  def mock_post(url, body, fixture)
    stub_request(:post, url).
      with(:body    => body,
           :headers => {
            'Accept'=>'application/json',
            'Authorization'=>'token'}).
      to_return(:status => 200, :body => read_fixture("github/#{fixture}.json"), :headers => {})
  end

  def mock_delete(url, body)
    stub_request(:delete, url).
      with(:body => body,
           :headers => {
            'Accept'=>'application/json',
            'Authorization'=>'token'}).
      to_return(:status => 204, :body => '')
  end

end