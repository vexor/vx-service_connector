require 'spec_helper'

describe Vx::ServiceConnector::Github do

  include GithubWebMocks

  let(:login)     { 'login' }
  let(:token)     { 'token' }
  let(:repo_name) { 'test' }
  let(:github)    { described_class.new login, token }

  subject { github }

  it { should be }

  context "(notice)" do
    subject { github.notice }

    context "create" do
      let(:sha)  { 'sha' }
      let(:url)  { 'url' }
      let(:desc) { 'description' }

      { started: "pending",  passed: "success", failed: "failure", errored: "error"}.each do |k,v|
        context "#{k}" do
          subject { github.notice.create repo_name, sha, k, url, desc }
          before do
            mock_post "https://api.github.com/repos/test/statuses/sha",
                      "{\"description\":\"description\",\"target_url\":\"url\",\"state\":\"#{v}\"}",
                      "create_status"
          end
          it { should be }
        end
      end
    end
  end

  context "(repos)" do
    subject { github.repos }

    before do
      mock_user_repos
      mock_org_repos
      mock_orgs
    end

    it { should have(2).item }

    context "values" do
      subject { github.repos.map(&:values) }
      it do
        should eq(
          [[1296269, "octocat/user", false,
            "git@github.com:octocat/Hello-World.git",
            "https://github.com/octocat/Hello-World"],
           [1296269, "octocat/org", false,
            "git@github.com:octocat/Hello-World.git",
            "https://github.com/octocat/Hello-World"]]
        )
      end
    end
  end

  context "(deploy_key)" do
    let(:key_name)   { 'octocat@octomac' }
    let(:public_key) { 'public key' }
    let(:deploy_key) { github.deploy_key }

    context "add" do
      subject { deploy_key.add repo_name, key_name, public_key }

      before do
        mock_add_deploy_key
      end

      it { should be }
    end

    context "remove" do
      subject { deploy_key.remove repo_name, key_name}

      before do
        mock_deploy_keys
        mock_delete_deploy_key
      end

      it { should have(1).item }
    end
  end

  context "(hook)" do
    let(:url)   { 'url' }
    let(:token) { 'token' }
    let(:hook)  { github.hook }

    context "add" do
      subject { hook.add repo_name, url, token }
      before do
        mock_add_hook
      end
      it { should be }
    end

    context "remove" do
      let(:mask) { "http://example.com" }
      subject { hook.remove repo_name, mask }
      before do
        mock_hooks
        mock_remove_hook
      end
      it { should have(1).item }
    end
  end


end
