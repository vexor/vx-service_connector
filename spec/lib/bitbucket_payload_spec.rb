require 'spec_helper'

describe Vx::ServiceConnector::Bitbucket::Payload do

  include BitbucketWebMocks

  let(:content)    { read_json_fixture "bitbucket/payload/push" }
  let(:bitbucket)  { Vx::ServiceConnector::Bitbucket.new 'login', 'token' }
  let(:repo)       { create :repo }
  let(:payload)    { bitbucket.payload repo, content }
  subject { payload }

  context "push" do
    let(:url) { "https://bitbucket.org/login/api-test/commits/fcced6e76504a5fba74eb05de7cefa819db272c7"  }

    its(:ignore?)             { should be_false }
    its(:pull_request?)       { should be_false }
    its(:pull_request_number) { should be_nil }
    its(:branch)              { should eq 'master' }
    its(:branch_label)        { should eq 'master' }
    its(:sha)                 { should eq 'fcced6e76504a5fba74eb05de7cefa819db272c7' }
    its(:message)             { should eq 'test commit' }
    its(:author)              { should eq 'login' }
    its(:author_email)        { should eq 'example@gmail.com' }
    its(:web_url)             { should eq url }
  end

  context "create pull_request" do
    let(:content) { read_json_fixture("bitbucket/payload/created_pull_request") }
    let(:url)     { "https://bitbucket.org/login/api-test/pull-request/5" }
    let(:sha)     { 'b8aed32b8a30' }

    before do
      mock_get_commit 'login/api-test', sha
    end

    its(:ignore?)             { should be_true }
    its(:pull_request?)       { should be_true }
    its(:pull_request_number) { should eq 5 }
    its(:branch)              { should eq 'fix' }
    its(:branch_label)        { should eq 'fix' }
    its(:sha)                 { should eq sha }
    its(:message)             { should eq 'Fix all the bugs' }
    its(:author)              { should eq 'login' }
    its(:author_email)        { should eq 'example@gmail.com' }
    its(:web_url)             { should eq url }

  end

end
