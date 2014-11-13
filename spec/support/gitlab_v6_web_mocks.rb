require_relative "gitlab_web_mocks"

module GitlabV6WebMocks
  include GitlabWebMocks

  def mock_get(url, fixture)
    stub_request(:get, "http://example.com/api/v3/#{url}").
      with(:headers => {'Accept'=>'application/json', 'PRIVATE-TOKEN' => "token"}).
      to_return(
        :status => 200,
        :body => read_fixture("gitlab_v6/#{fixture}.json"),
        :headers => {'Content-Type' => 'application/json'})
  end

  def mock_remove_hook
    mock_delete "projects/1/hooks/57", ""
  end

  def mock_get_commit(pid, sha)
    mock_get "projects/#{pid}/repository/commits/#{sha}", 'commit'
  end

  def mock_get_tag(pid, sha)
    mock_get_commit(pid, sha)
  end

  def mock_branch(pid, branch_name)
    mock_get "projects/#{pid}/repository/branches/#{branch_name}", 'branch'
  end

  def mock_project(pid)
    mock_get "projects/#{pid}", 'project'
  end

  def mock_project_not_found(pid)
    stub_request(:get, "http://example.com/api/v3/projects/#{pid}").
      with(:headers => {'Accept'=>'application/json', 'PRIVATE-TOKEN' => "token"}).
      to_return(
        :status => 404,
        :body => {:status=>"404", :error=>"Not Found"}.to_json,
        :headers => {'Content-Type' => 'application/json'})
  end

  def mock_get_commit_not_found(pid, sha)
    stub_request(:get, "http://example.com/api/v3/projects/#{pid}/repository/commits/#{sha}").
      with(:headers => {'Accept'=>'application/json', 'PRIVATE-TOKEN' => "token"}).
      to_return(
        :status => 404,
        :body => {:status=>"404", :error=>"Not Found"}.to_json,
        :headers => {'Content-Type' => 'application/json'})
  end

  def mock_branch_not_found(pid, name)
    stub_request(:get, "http://example.com/api/v3/projects/#{pid}/repository/branches/#{name}").
      with(:headers => {'Accept'=>'application/json', 'PRIVATE-TOKEN' => "token"}).
      to_return(
        :status => 404,
        :body => {:status=>"404", :error=>"Not Found"}.to_json,
        :headers => {'Content-Type' => 'application/json'})
  end
end
