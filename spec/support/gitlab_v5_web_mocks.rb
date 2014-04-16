require_relative "gitlab_web_mocks"

module GitlabV5WebMocks
  include GitlabWebMocks

  def mock_get(url, fixture)
    stub_request(:get, "http://example.com/api/v3/#{url}").
      with(:headers => {'Accept'=>'application/json', 'PRIVATE-TOKEN' => "token"}).
      to_return(
        :status => 200,
        :body => read_fixture("gitlab_v5/#{fixture}.json"),
        :headers => {'Content-Type' => 'application/json'})
  end

  def mock_remove_hook
    mock_delete "projects/1/hooks?hook_id=57", ""
  end

  def mock_get_commit(pid, sha)
    mock_get "projects/#{pid}/repository/commits?ref_name=#{sha}", 'commits'
  end
end
