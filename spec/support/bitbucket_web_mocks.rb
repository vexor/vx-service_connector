module BitbucketWebMocks

  def mock_get_last_commit(repo_name)
    mock_get "https://bitbucket.org/api/1.0/repositories/#{repo.full_name}/changesets/?limit=1", 'changesets'
  end

  def mock_get_commit(repo_name, sha)
    mock_get "https://bitbucket.org/api/2.0/repositories/#{repo_name}/commit/#{sha}", 'commit'
  end

  def mock_repo
    mock_get 'https://bitbucket.org/api/2.0/repositories/full/name', 'user_repo'
  end

  def mock_user_repos
    mock_get "https://bitbucket.org/api/1.0/user/repositories", "repos"
  end

  def mock_user_privileges
    mock_get "https://bitbucket.org/api/1.0/user/privileges", "user_privileges"
  end

  def mock_deploy_keys
    mock_get "https://bitbucket.org/api/1.0/repositories/full/name/deploy-keys?pagelen=100",
             "deploy_keys"
  end

  def mock_delete_deploy_key
    mock_delete "https://bitbucket.org/api/1.0/repositories/full/name/deploy-keys/929688", ""
  end

  def mock_add_deploy_key
    mock_post "https://bitbucket.org/api/1.0/repositories/full/name/deploy-keys",
              {"key"=>"public key", "label"=>"foo"},
              "add_deploy_key"
  end

  def mock_add_hook
    mock_post "https://bitbucket.org/api/1.0/repositories/full/name/services",
              {"type" => "POST", "URL" => "https://example.com"},
              "create_hook"
    mock_post "https://bitbucket.org/api/1.0/repositories/full/name/services",
              {"URL"=>"https://example.com", "approve/unapprove"=>"off", "comments"=>"off", "create/edit/merge/decline"=>"on", "type"=>"Pull Request POST"},
              "create_hook"
  end

  def mock_hooks
    mock_get 'https://bitbucket.org/api/1.0/repositories/full/name/services',
             'hooks'
  end

  def mock_remove_hook
    mock_delete  "https://bitbucket.org/api/1.0/repositories/full/name/services/4115444", ""
    mock_delete  "https://bitbucket.org/api/1.0/repositories/full/name/services/4115443", ""
  end

  def mock_get_file
    stub_request(:get, "https://bitbucket.org/api/1.0/repositories/full/name/src/sha/path").
      to_return(:status => 200, :body => "content")
  end

  def mock_get_file_not_found
    stub_request(:get, "https://bitbucket.org/api/1.0/repositories/full/name/src/sha/path").
      with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json', 'Authorization'=>'token'}).
      to_return(:status => 404, :body => "")
  end

  private

  def mock_get(url, fixture)
    stub_request(:get, url).
      to_return(
        :status => 200,
        :body => read_fixture("bitbucket/#{fixture}.json"),
        :headers => {'Content-Type' => 'application/json'})
  end

  def mock_post(url, body, fixture)
    stub_request(:post, url).
      with(:body    => body).
      to_return(:status => 200, :body => read_fixture("github/#{fixture}.json"), :headers => {})
  end

  def mock_delete(url, body)
    stub_request(:delete, url).
      with(:body => body).
      to_return(:status => 204, :body => '')
  end

end
