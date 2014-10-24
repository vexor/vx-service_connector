require 'spec_helper'

describe Vx::ServiceConnector::Bitbucket do

  include BitbucketWebMocks

  let(:login)     { 'dmexe' }
  let(:token)     { 'token' }
  let(:repo)      { create :repo }
  let(:bitbucket) {
    Vx::ServiceConnector::Bitbucket.new login, Vx::ServiceConnector::Bitbucket::Session.test
  }

  subject { bitbucket }

  it { should be }

  context "(commits)" do
    let(:commits) { bitbucket.commits(repo) }

    it "should return payload for last commit" do
      mock_get_last_commit repo.full_name
      c = commits.last
      expect(c).to be
      expect(c.message).to eq "test\n"
      expect(c.skip).to be_false
      expect(c.pull_request?).to be_false
      expect(c.branch).to eq 'test'
      expect(c.branch_label).to eq 'test'
      expect(c.sha).to eq '5bf6aff99e8350c493ecce2016c50d977de88d6f'
      expect(c.author).to eq 'Dmitry Galinsky'
      expect(c.author_email).to eq 'dima.exe@gmail.com'
      expect(c.web_url).to eq 'https://bitbucket.org/full/name/commits/5bf6aff99e8350c493ecce2016c50d977de88d6f'
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

    it { should have(3).item }

    context "values" do
      subject { bitbucket.repos.map(&:values) }

      it { should eq(

        [
          ["121111foobar/vx-promo",
           "121111foobar/vx-promo",
           false,
           "git@bitbucket.org:121111foobar/vx-promo.git",
           "https://bitbucket.org/121111foobar/vx-promo",
           "", nil],
         ["dmexe/demo",
          "dmexe/demo",
          true,
          "git@bitbucket.org:dmexe/demo.git",
          "https://bitbucket.org/dmexe/demo",
          "", nil],
         ["dmexe/vx-binutils",
          "dmexe/vx-binutils",
          false,
          "git@bitbucket.org:dmexe/vx-binutils.git",
          "https://bitbucket.org/dmexe/vx-binutils",
          "", nil]]
      ) }

    end
  end

  context "(deploy_keys)" do
    let(:key_name)    { 'foo' }
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
      it { should have(2).item }
    end
  end

=begin
  context "(files)" do
    let(:sha)  { 'sha' }
    let(:path) { 'path' }

    context "get" do
      subject { bitbucket.files(repo).get sha, path }

      context "success" do
        before { mock_get_file }
        it { should eq 'content' }
      end

      context "not found" do
        before { mock_get_file_not_found }
        it { should be_nil }
      end
    end
  end
=end

end
