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

  def mock_get(url, fixture)
    stub_request(:get, url).
      with(:headers => {'Accept'=>'application/json', 'PRIVATE-TOKEN' => "token"}).
      to_return(
        :status => 200,
        :body => read_fixture("bitbucket/#{fixture}.json"),
        :headers => {'Content-Type' => 'application/json'})
  end

  def mock_post(url, body, fixture)
  end

  def mock_delete(url, body)
  end

end