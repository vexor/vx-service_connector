require 'spec_helper'

describe Vx::ServiceConnector::Bitbucket::Payload do

  include BitbucketWebMocks

  let(:content)    { read_json_fixture 'bitbucket/payload/push' }
  let(:bitbucket)  {
    Vx::ServiceConnector::Bitbucket.new 'login', Vx::ServiceConnector::Bitbucket::Session.test
  }
  let(:repo)       { create :repo }
  let(:payload)    { bitbucket.payload repo, content }
  subject { payload }

  context 'push' do
    let(:url) { "https://bitbucket.org/121111foobar/vx-promo/commits/e4958d88c9055ca471618f004c6f6b2d79965267"}

    its(:ignore?)             { should be_false }
    its(:pull_request?)       { should be_false }
    its(:pull_request_number) { should be_nil }
    its(:branch)              { should eq 'master' }
    its(:branch_label)        { should eq 'master' }
    its(:sha)                 { should eq 'e4958d88c9055ca471618f004c6f6b2d79965267' }
    its(:message)             { should eq "test\n" }
    its(:author)              { should eq 'dmexe' }
    its(:author_email)        { should eq 'dima.exe@gmail.com' }
    its(:web_url)             { should eq url }
  end

  context 'create pull_request' do
    let(:content) { read_json_fixture 'bitbucket/payload/created_pull_request' }
    let(:url)     { 'https://bitbucket.org/121111foobar/vx-promo/pull-request/1' }
    let(:sha)     { 'b14806535f5e' }

    before do
      mock_get_commit '121111foobar/vx-promo', sha
    end

    its(:ignore?)             { should be_false }
    its(:pull_request?)       { should be_true }
    its(:pull_request_number) { should eq 1 }
    its(:branch)              { should eq 'test' }
    its(:branch_label)        { should eq 'test' }
    its(:sha)                 { should eq sha }
    its(:message)             { should eq 'Fix all the bugs' }
    its(:author)              { should eq 'login' }
    its(:author_email)        { should eq 'example@gmail.com' }
    its(:web_url)             { should eq url }
  end

  context 'declined pull request' do
    let(:content) { read_json_fixture('bitbucket/payload/declined_pull_request') }

    before do
      mock_get_commit 'login/api-test', 'b8aed32b8a30'
    end

    its(:ignore?) { should be_true }
  end

  context 'foreign pull request' do
    let(:content) { read_json_fixture 'bitbucket/payload/foreign_pull_request' }

    before do
      mock_get_commit 'other_login/api-test', 'b8aed32b8a30'
    end

    it { should_not be_ignore }
    it { should be_pull_request }
    it { should be_foreign_pull_request }
    it { should_not be_internal_pull_request }
  end

  context 'pull request with same repo' do

    let(:content) { read_json_fixture 'bitbucket/payload/created_pull_request' }

    before do
       mock_get_commit '121111foobar/vx-promo', 'b14806535f5e'
    end

    its(:ignore?) { should be_false }
  end

  context 'push with empty commits' do

    let(:content) { read_json_fixture 'bitbucket/payload/bug_1_empty_commits' }

    its(:ignore?) { should be_true }
  end

  context 'push with empty commits in PR' do

    let(:content) { read_json_fixture 'bitbucket/payload/bug_2_empty_commits' }

    its(:ignore?) { should be_true }
  end

end
