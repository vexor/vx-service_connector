require 'spec_helper'

describe Vx::ServiceConnector::Bitbucket::Payload do

  include BitbucketWebMocks

  # let(:content) { read_json_fixture("bitbucket/payload/push") }
  # let(:bitbucket)  { Vx::ServiceConnector::Bitbucket.new 'login', 'token' }
  # let(:repo)    { create :repo }
  # let(:payload) { bitbucket.payload repo, content }
  # subject { payload }

  # context "push" do
  #   let(:url) { "https://bitbucket.org/tarasu/api-test/commits/0a1fb3a24b8ceb48a16fb09a5759cd6f8a930463"  }

  #   its(:pull_request?)       { should be_false }
  #   its(:pull_request_number) { should be_nil }
  #   its(:sha)                 { should eq '0a1fb3a24b8ceb48a16fb09a5759cd6f8a930463' }
  #   its(:branch)              { should eq 'master' }
  #   its(:branch_label)        { should eq 'master' }
  #   its(:message)             { should eq 'test commit #3' }
  #   its(:author)              { should eq 'Dmitry Galinsky' }
  #   its(:author_email)        { should eq 'dima.exe@gmail.com' }
  #   its(:web_url)             { should eq url }
  #   its(:ignore?)             { should be_false }
  # end

  # context "pull_request" do
  #   let(:content) { read_json_fixture("bitbucket/payload/pull_request") }
  #   let(:url)     { "https://bitbucket.org/tarasu/api-test/pull-request/1/test-pull-request/diff" }
  #   let(:sha)     { '0a1fb3a24b8ceb48a16fb09a5759cd6f8a930463' }

  #   before do
  #     mock_get_commit 'evrone/cybergifts', sha
  #   end

  #   its(:pull_request?)       { should be_true }
  #   its(:pull_request_number) { should eq 177 }
  #   its(:sha)                 { should eq sha }
  #   its(:branch)              { should eq 'test' }
  #   its(:branch_label)        { should eq 'dima-exe:test' }
  #   its(:message)             { should eq 'Fix all the bugs' }
  #   its(:author)              { should eq 'Monalisa Octocat' }
  #   its(:author_email)        { should eq 'support@github.com' }
  #   its(:web_url)             { should eq url }
  #   its(:ignore?)             { should be_true }
  # end

  # context "push tag" do
  #   let(:content) { read_json_fixture("github/payload/push_tag") }
  #   its(:ignore?) { should be_true }
  # end

  # context "closed pull request" do
  #   let(:content) { read_json_fixture("github/payload/closed_pull_request") }

  #   before do
  #     mock_get_commit 'evrone/cybergifts', '84158c732ff1af3db9775a37a74ddc39f5c4078f'
  #   end

  #   its(:ignore?) { should be_true }
  # end

  # context "foreign pull request" do
  #   let(:content) { read_json_fixture("github/payload/foreign_pull_request") }

  #   before do
  #     mock_get_commit 'evrone/serverist-email-provider', 'f57c385116139082811442ad48cb6127c29eb351'
  #   end

  #   its(:ignore?) { should be_false }
  # end

  # context "pull request with same repo" do

  #   let(:content) { read_json_fixture("github/payload/pull_request") }

  #   before do
  #     mock_get_commit 'evrone/cybergifts', '84158c732ff1af3db9775a37a74ddc39f5c4078f'
  #   end

  #   its(:ignore?) { should be_true }
  # end

end
