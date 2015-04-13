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

  context "repos class" do
    subject { repos }

    let(:repos)   { described_class::Repos.new session }
    let(:team)    { "team2" }
    let(:session) {
      described_class::Session.new login, described_class::Session.test
    }

    before do
      mock_repos("dmexe", "repos_team1")
      mock_repos("team2", "repos_team2")
      mock_teams
    end

    it "has correct teams" do
      expect(subject.send :teams).to eq [team]
    end

    context "repos by_username" do
      subject do
        repos.send(:by_username, username).map(&:full_name)
      end

      context "login" do
        let(:username) { login }

        it do
          should eq([
            "teamsinspace/design-bucket1",
            "teamsinspace/teamsinspace.bitbucket.org1"
          ])
        end
      end

      context "team" do
        let(:username) { team }

        it do
          should eq([
            "teamsinspace/design-bucket2",
            "teamsinspace/teamsinspace.bitbucket.org2"
          ])
        end
      end
    end


    context "all repos" do
      subject do
        repos.send(:all_repos).map(&:full_name)
      end

      it do
        should eq([
          "teamsinspace/design-bucket1",
          "teamsinspace/teamsinspace.bitbucket.org1",
          "teamsinspace/design-bucket2",
          "teamsinspace/teamsinspace.bitbucket.org2"
        ])
      end
    end

    context "repos" do
      subject { bitbucket.repos.map(&:values) }

      it do
        should eq([
          [
            "teamsinspace/design-bucket1",
            "teamsinspace/design-bucket1",
            false,
            "git@bitbucket.org:teamsinspace/design-bucket1.git",
            "https://bitbucket.org/teamsinspace/design-bucket1",
            "",
            nil
          ],
          [
            "teamsinspace/teamsinspace.bitbucket.org1",
            "teamsinspace/teamsinspace.bitbucket.org1",
            false,
            "git@bitbucket.org:teamsinspace/teamsinspace.bitbucket.org1.git",
            "https://bitbucket.org/teamsinspace/teamsinspace.bitbucket.org1",
            "",
            nil
          ],
          [
            "teamsinspace/design-bucket2",
            "teamsinspace/design-bucket2",
            false,
            "git@bitbucket.org:teamsinspace/design-bucket2.git",
            "https://bitbucket.org/teamsinspace/design-bucket2",
            "",
            nil
          ],
          [
            "teamsinspace/teamsinspace.bitbucket.org2",
            "teamsinspace/teamsinspace.bitbucket.org2",
            false,
            "git@bitbucket.org:teamsinspace/teamsinspace.bitbucket.org2.git",
            "https://bitbucket.org/teamsinspace/teamsinspace.bitbucket.org2",
            "",
            nil
          ]
        ])
      end
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
