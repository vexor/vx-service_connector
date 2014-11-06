require 'spec_helper'

describe Vx::ServiceConnector::GitlabV6::Payload do

  include const_get("GitlabV6WebMocks")

  let(:content) { read_json_fixture("gitlab_v6/payload/push") }
  let(:repo)    { create :repo }
  let(:gitlab)  { Vx::ServiceConnector::GitlabV6.new 'http://example.com', 'token' }
  let(:payload) { gitlab.payload(repo, content) }
  subject { payload }

  context "foreign pull request" do
    let(:content) { read_json_fixture("gitlab_v6/payload/merge_request") }
    let(:sha)     { 'a7c31647c6449c3d98c4027d97e00b3048ac3bbf' }

    before do
      mock_get_commit 1, sha
      mock_branch 1, "some-branch-name"
      mock_project 1
    end

    it { should be_pull_request }
    it { should be_foreign_pull_request }
    it { should_not be_internal_pull_request }

    its(:pull_request_number) { should eq 5 }
    its(:sha)                 { should eq sha }
    its(:branch)              { should eq 'some-branch-name' }
    its(:message)             { should eq 'Replace sanitize with escape once' }
    its(:author)              { should eq 'Dmitriy Zaporozhets' }
    its(:author_email)        { should eq 'dzaporozhets@sphereconsultinginc.com' }
    its(:web_url)             { should eq "http://localhost/example/sqerp/merge_requests/5" }
    its(:ignore?)             { should be_false }
  end

  context "push tag" do
    let(:sha) { 'decc3915e29d7ae1786bb981b2ea3702afae592a' }

    before do
      mock_get_tag 1, sha
    end

    let(:content) { read_json_fixture("gitlab_v6/payload/push_tag") }
    it { should_not be_ignore }
    it { should be_tag }
    its(:tag) { should eq 'v1' }
  end

  context "closed pull request" do
    let(:content) { read_json_fixture("gitlab_v6/payload/closed_merge_request") }

    before do
      mock_project 1
    end

    it { should be_pull_request }
    it { should be_ignore }
  end

  context "merged pull request" do
    let(:content) { read_json_fixture("gitlab_v6/payload/merged_merge_request") }

    before do
      mock_project 1
    end

    it { should be_pull_request }
    it { should be_ignore }
  end

  context "when identity is not authorized on push request" do
    before do
      mock_project_not_found 1
      mock_get_commit_not_found 1, "decc3915e29d7ae1786bb981b2ea3702afae592a"
    end
    its(:ignore?) { should be_true }
  end

  context "when identity is not authorized on merge request" do
    let(:content) { read_json_fixture("gitlab_v6/payload/merge_request") }
    before do
      mock_project_not_found 1
      mock_branch_not_found 1, "some-branch-name"
      mock_get_commit_not_found 1, "a7c31647c6449c3d98c4027d97e00b3048ac3bbf"
    end
    its(:ignore?) { should be_true }
  end

end
