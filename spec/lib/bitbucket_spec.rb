require 'spec_helper'

describe Vx::ServiceConnector::Bitbucket do

  include BitbucketWebMocks

  let(:login)     { 'login' }
  let(:token)     { 'token' }
  let(:repo)      { create :repo }
  let(:bitbucket)    { described_class.new login, token }

  subject { bitbucket }

  it { should be }

  context "(commits)" do
    let(:commits) { bitbucket.commits(repo) }

    it "should return payload for last commit" do
      mock_get_commit repo.full_name
      c = commits.last
      expect(c).to be
      expect(c.message).to eq "Fix all the bugs"
      expect(c.skip).to be_false
      expect(c.pull_request?).to be_false
      expect(c.branch).to eq 'master'
      expect(c.branch_label).to eq 'master'
      expect(c.sha).to eq '0a1fb3a24b8ceb48a16fb09a5759cd6f8a930463'
      expect(c.author).to eq 'login'
      expect(c.author_email).to eq 'zazazip@yandex.ru'
      expect(c.web_url).to eq 'https://bitbucket.org/login/api-test/commits/0a1fb3a24b8ceb48a16fb09a5759cd6f8a930463'
    end
  end

  # context "(notices)" do
  # end

  context "(repos)" do
    subject { bitbucket.repos }

    before do
      mock_user_repos
      mock_user_privileges
    end

    it { should have(2).item }

    context "values" do
      subject { bitbucket.repos.map(&:values) }

      it { should eq(
        [["{b890dc44-b05d-4e0b-a0a4-6b5946e31603}",
          "login/res", false,
          "ssh://git@bitbucket.org/login/res.git",
          "https://bitbucket.org/login/res",
          "This your first repo!"],
         ["{7f4500f2-d3a7-4757-9f92-709d5976720c}",
          "login/api-test", false,
          "ssh://git@bitbucket.org/login/api-test.git",
          "https://bitbucket.org/login/api-test",
          "repo for test api"]]
      ) }

    end
  end

  context "(deploy_keys)" do
    let(:key_name)    { 'octocat@octomac' }
    let(:public_key)  { 'public key' }
    let(:deploy_keys) { bitbucket.deploy_keys(repo) }

    context "all" do
      subject { deploy_keys.all }
      before { mock_deploy_keys }
      it { should have(1).item }
    end

    context "create" do
      subject { deploy_keys.create key_name, public_key }
      before { mock_add_deploy_key }
      it { should be }
    end

    context "destroy" do
      subject { deploy_keys.destroy key_name}
      before do
        mock_deploy_keys
        mock_delete_deploy_key
      end

      it { should have(1).item }
    end
  end

  context "(hooks)" do
    let(:url)   { 'https://example.com' }
    let(:token) { 'token' }
    let(:hooks) { bitbucket.hooks(repo) }

    context "all" do
      subject { hooks.all }
      before { mock_hooks }
      it { should have(2).item }
    end

    context "create" do
      subject { hooks.create url, token }
      before { mock_add_hook }
      it { should be }
    end

    context "destroy" do
      let(:mask) { "http://example.com" }
      subject { hooks.destroy mask }
      before do
        mock_hooks
        mock_remove_hook
      end
      it { should have(1).item }
    end
  end

  # context "(files)" do
  # end

end
