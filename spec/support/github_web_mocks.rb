module GithubWebMocks

  def mock_get_commit(repo_name, sha)
    mock_get "https://api.github.com/repos/#{repo_name}/commits/#{sha}", 'commit'
  end

  def mock_get_commit_not_found
    stub_request(:get, "https://api.github.com/repos/full/name/commits/sha").
      to_return(:status => 404, :body => "")
  end

  def mock_create_notice(state)
    mock_post "https://api.github.com/repos/full/name/statuses/sha",
              "{\"description\":\"description\",\"target_url\":\"url\",\"state\":\"#{state}\"}",
              "create_status"
  end

  def mock_remove_hook
    mock_delete  "https://api.github.com/repos/full/name/hooks/1", "{}"
  end

  def mock_hooks
    mock_get "https://api.github.com/repos/full/name/hooks?per_page=100",
             "hooks"
  end

  def mock_add_hook
    mock_post "https://api.github.com/repos/full/name/hooks",
              "{\"name\":\"web\",\"config\":{\"url\":\"url\",\"secret\":\"token\",\"content_type\":\"json\"},\"events\":[\"push\",\"pull_request\"],\"active\":true}",
              "create_hook"
  end

  def mock_deploy_keys
    mock_get "https://api.github.com/repos/full/name/keys?per_page=100", "deploy_keys"
  end

  def mock_delete_deploy_key
    mock_delete "https://api.github.com/repos/full/name/keys/1", "{}"
  end

  def mock_add_deploy_key
    mock_post "https://api.github.com/repos/full/name/keys",
              "{\"title\":\"octocat@octomac\",\"key\":\"public key\"}",
              "add_deploy_key"
  end

  def mock_user_repos
    mock_get "https://api.github.com/user/repos?per_page=100", "user_repos"
  end

  def mock_repo
    mock_get "https://api.github.com/repos/full/name", "user_repo"
  end

  def mock_org_repos
    mock_get "https://api.github.com/orgs/github/repos?per_page=100", "org_repos"
  end

  def mock_orgs
    mock_get "https://api.github.com/user/orgs", "orgs"
  end

  def mock_get_file
    require 'base64'
    require 'json'

    content = { "content" => Base64.encode64('content') }.to_json
    mock_get "https://api.github.com/repos/full/name/contents/path?ref=sha", nil, content: content
  end

  def mock_get_file_not_found
    stub_request(:get, "https://api.github.com/repos/full/name/contents/path?ref=sha").
      to_return(:status => 404, :body => "")
  end

  def mock_post(url, body, fixture)
    stub_request(:post, url).
      with(:body    => body,
           :headers => {
            'Accept'=>'application/vnd.github.beta+json',
            'Authorization'=>'token token'}).
      to_return(:status => 200, :body => read_fixture("github/#{fixture}.json"), :headers => {})
  end

  def mock_get(url, fixture, options = {})
    content = options[:content]
    content ||= read_fixture("github/#{fixture}.json")
    content_type = options[:content_type] || 'application/json'
    stub_request(:get, url).
      with(:headers => {
        'Accept'=>'application/vnd.github.beta+json',
        'Authorization'=>'token token'}).
      to_return(
        :status => 200,
        :body => content,
        :headers => {'Content-Type'=> content_type})
  end

  def mock_delete(url, body)
    stub_request(:delete, url).
      with(:body => body,
           :headers => {'Accept'=>'application/vnd.github.beta+json', 'Authorization'=>'token token'}).
      to_return(:status => 200, :body => "")
  end
end
