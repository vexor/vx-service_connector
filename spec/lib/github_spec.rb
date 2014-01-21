require 'spec_helper'

describe Vx::ServiceConnector::Github do

  include GithubWebMocks

  let(:login)     { 'login' }
  let(:token)     { 'token' }
  let(:repo)      { create :repo }
  let(:github)    { described_class.new login, token }

  subject { github }

  it { should be }

  context "(notices)" do
    let(:notices) { github.notices(repo) }

    context "create" do
      let(:sha)  { 'sha' }
      let(:url)  { 'url' }
      let(:desc) { 'description' }

      { started: "pending",  passed: "success", failed: "failure", errored: "error"}.each do |k,v|
        context "#{k}" do
          subject { notices.create sha, k, url, desc }
          before { mock_create_notice(v) }
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
      it { should eq(
        [[1296269, "octocat/user", false,
          "git@github.com:octocat/Hello-World.git",
          "https://github.com/octocat/Hello-World"],
         [1296269, "octocat/org", false,
          "git@github.com:octocat/Hello-World.git",
          "https://github.com/octocat/Hello-World"]]
      ) }
    end
  end

  context "(deploy_keys)" do
    let(:key_name)    { 'octocat@octomac' }
    let(:public_key)  { 'public key' }
    let(:deploy_keys) { github.deploy_keys(repo) }

    context "all" do
      subject { deploy_keys.all }
      before { mock_deploy_keys }
      it { should have(1).item }
    end

    context "add" do
      subject { deploy_keys.add key_name, public_key }
      before { mock_add_deploy_key }
      it { should be }
    end

    context "remove" do
      subject { deploy_keys.remove key_name}

      before do
        mock_deploy_keys
        mock_delete_deploy_key
      end

      it { should have(1).item }
    end
  end

  context "(hooks)" do
    let(:url)   { 'url' }
    let(:token) { 'token' }
    let(:hooks) { github.hooks(repo) }

    context "all" do
      subject { hooks.all }
      before { mock_hooks }
      it { should have(1).item }
    end

    context "add" do
      subject { hooks.add url, token }
      before { mock_add_hook }
      it { should be }
    end

    context "remove" do
      let(:mask) { "http://example.com" }
      subject { hooks.remove mask }
      before do
        mock_hooks
        mock_remove_hook
      end
      it { should have(1).item }
    end
  end

  context "(files)" do
    let(:sha)  { 'sha' }
    let(:path) { 'path' }

    context "get" do
      subject { github.files(repo).get sha, path }

      context "success" do
        before { mock_get_file  }
        it { should eq 'content' }
      end

      context "not found" do
        before { mock_get_file_not_found }
        it { should be_nil }
      end
    end
  end
end
