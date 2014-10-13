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
      mock_default_branch
      mock_get_commit repo.full_name, 'master'
      c = commits.last
      expect(c).to be
      expect(c.message).to eq "Fix all the bugs"
      expect(c.skip).to be_false
      expect(c.pull_request?).to be_false
      expect(c.branch).to eq 'master'
      expect(c.branch_label).to eq 'master'
      expect(c.sha).to eq '0a1fb3a24b8ceb48a16fb09a5759cd6f8a930463'
      expect(c.author).to eq 'tarasu'
      expect(c.author_email).to eq 'zazazip@yandex.ru'
      expect(c.web_url).to eq 'https://bitbucket.org/tarasu/api-test/commits/0a1fb3a24b8ceb48a16fb09a5759cd6f8a930463'
    end
  end

  # context "(notices)" do
  #   let(:notices) { github.notices(repo) }

  #   context "create" do
  #     let(:sha)  { 'sha' }
  #     let(:url)  { 'url' }
  #     let(:desc) { 'description' }

  #     { started: "pending",  passed: "success", failed: "failure", errored: "error"}.each do |k,v|
  #       context "#{k}" do
  #         subject { notices.create sha, k, url, desc }
  #         before { mock_create_notice(v) }
  #         it { should be }
  #       end
  #     end
  #   end
  # end

  context "(repos)" do
    subject { bitbucket.repos }

    before do
      mock_user_repos
      mock_teams
      mock_team_repos
    end

    it { should have(4).item }

    context "values" do
      subject { bitbucket.repos.map(&:values) }

      it { should eq(
        [["{b890dc44-b05d-4e0b-a0a4-6b5946e31603}",
          "tarasu/res", false,
          "ssh://git@bitbucket.org/tarasu/res.git",
          "https://bitbucket.org/tarasu/res",
          "This your first repo!"],
         ["{7f4500f2-d3a7-4757-9f92-709d5976720c}",
          "tarasu/api-test", false,
          "ssh://git@bitbucket.org/tarasu/api-test.git",
          "https://bitbucket.org/tarasu/api-test",
          "repo for test api"],
          ["{817f084d-bd66-4eb0-97c3-f190637b2de7}", "bcarpenter/registration_templates", false,
          "ssh://hg@bitbucket.org/bcarpenter/registration_templates",
          "https://bitbucket.org/bcarpenter/registration_templates",
          "This your first repo!"],
          ["{7b38a811-939e-42d0-a986-9bc24abc3ba2}", "bcarpenter/spiderbee", false,
          "ssh://git@bitbucket.org/bcarpenter/spiderbee.git",
          "https://bitbucket.org/bcarpenter/spiderbee",
          "A open source project"]]
      ) }

    end
  end

  # context "(deploy_keys)" do
  #   let(:key_name)    { 'octocat@octomac' }
  #   let(:public_key)  { 'public key' }
  #   let(:deploy_keys) { github.deploy_keys(repo) }

  #   context "all" do
  #     subject { deploy_keys.all }
  #     before { mock_deploy_keys }
  #     it { should have(1).item }
  #   end

  #   context "create" do
  #     subject { deploy_keys.create key_name, public_key }
  #     before { mock_add_deploy_key }
  #     it { should be }
  #   end

  #   context "destroy" do
  #     subject { deploy_keys.destroy key_name}

  #     before do
  #       mock_deploy_keys
  #       mock_delete_deploy_key
  #     end

  #     it { should have(1).item }
  #   end
  # end

  # context "(hooks)" do
  #   let(:url)   { 'url' }
  #   let(:token) { 'token' }
  #   let(:hooks) { github.hooks(repo) }

  #   context "all" do
  #     subject { hooks.all }
  #     before { mock_hooks }
  #     it { should have(1).item }
  #   end

  #   context "create" do
  #     subject { hooks.create url, token }
  #     before { mock_add_hook }
  #     it { should be }
  #   end

  #   context "destroy" do
  #     let(:mask) { "http://example.com" }
  #     subject { hooks.destroy mask }
  #     before do
  #       mock_hooks
  #       mock_remove_hook
  #     end
  #     it { should have(1).item }
  #   end
  # end

  # context "(files)" do
  #   let(:sha)  { 'sha' }
  #   let(:path) { 'path' }

  #   context "get" do
  #     subject { github.files(repo).get sha, path }

  #     context "success" do
  #       before { mock_get_file  }
  #       it { should eq 'content' }
  #     end

  #     context "not found" do
  #       before { mock_get_file_not_found }
  #       it { should be_nil }
  #     end
  #   end
  # end

end
