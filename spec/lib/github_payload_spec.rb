require 'spec_helper'

describe Vx::ServiceConnector::Github::Payload do

  include GithubWebMocks

  let(:content) { read_json_fixture("github/payload/push") }
  let(:github)  { Vx::ServiceConnector::Github.new 'login', 'token' }
  let(:repo)    { create :repo }
  let(:payload) { github.payload repo, content }
  subject { payload }

  context "ping" do
    let(:content) { read_json_fixture 'github/payload/ping'  }
    it { should be_ignore }
  end

  context "push" do
    let(:url) { "https://github.com/evrone/ci-worker-test-repo/commit/687753389908e70801dd4ff5448be908642055c6"  }

    before do
      mock_get_commit_files(repo.full_name, "b665f90239563c030f1b280a434b3d84daeda1bd", "687753389908e70801dd4ff5448be908642055c6")
    end

    it { should_not be_ignore }

    its(:pull_request?)       { should be_false }
    its(:pull_request_number) { should be_nil }
    its(:sha)                 { should eq '84158c732ff1af3db9775a37a74ddc39f5c4078f' }
    its(:branch)              { should eq 'master' }
    its(:branch_label)        { should eq 'master' }
    its(:message)             { should eq 'test commit #3' }
    its(:author)              { should eq 'Dmitry Galinsky' }
    its(:author_email)        { should eq 'dima.exe@gmail.com' }
    its(:web_url)             { should eq url }
    its(:tag)                 { should be_nil }
    its(:files)               { should eq ["file1.txt", "file2.txt", "file3.txt"]}
  end

  context "internal pull_request" do
    let(:content) { read_json_fixture("github/payload/pull_request") }
    let(:url)     { "https://github.com/evrone/cybergifts/pull/177" }
    let(:sha)     { '84158c732ff1af3db9775a37a74ddc39f5c4078f' }

    before do
      mock_get_pull_files(repo.full_name, 177)
      mock_get_commit 'evrone/cybergifts', sha
    end

    its(:pull_request?)         { should be_true }
    its(:foreign_pull_request?) { should be_false }
    its(:internal_pull_request?){ should be_true }
    its(:pull_request_number)   { should eq 177 }
    its(:sha)                   { should eq sha }
    its(:branch)                { should eq 'test' }
    its(:branch_label)          { should eq 'dima-exe:test' }
    its(:message)               { should eq 'Fix all the bugs' }
    its(:author)                { should eq 'Monalisa Octocat' }
    its(:author_email)          { should eq 'support@github.com' }
    its(:web_url)               { should eq url }
    its(:ignore?)               { should be_false }
    its(:files)                 { should eq ["file1.txt", "file2.txt"]}
  end

  context "Octokit exceptions" do
    let(:content) { read_json_fixture("github/payload/pull_request") }
    let(:url)     { "https://github.com/evrone/cybergifts/pull/177" }
    let(:sha)     { '84158c732ff1af3db9775a37a74ddc39f5c4078f' }

    context "not found" do
      before do
        mock_get_commit_not_found("evrone/cybergifts", sha)
      end

      it { should be_ignore }
    end

    context "uanuthorized" do
      before do
        mock_get_commit_unauthorized("evrone/cybergifts", sha)
      end

      it { should be_ignore }
    end
  end

  context "push tag" do
    let(:content) { read_json_fixture("github/payload/push_tag") }

    before do
      mock_get_commit_files(repo.full_name, "0000000000000000000000000000000000000000", "c391528c6fd03cbf9bc74b8ac42e0a50d953eeea")
    end

    it { should_not be_pull_request }
    it { should_not be_ignore }
    it { should be_tag }
    its(:tag) { should eq 'v0.0.1' }
  end

  context "closed pull request" do
    let(:content) { read_json_fixture("github/payload/closed_pull_request") }

    before do
      mock_get_pull_files(repo.full_name, 177)
      mock_get_commit 'evrone/cybergifts', '84158c732ff1af3db9775a37a74ddc39f5c4078f'
    end
    it { should be_pull_request }
    its(:ignore?) { should be_true }
  end

  context "foreign pull request" do
    let(:content) { read_json_fixture("github/payload/foreign_pull_request") }

    before do
      mock_get_pull_files(repo.full_name, 1)
      mock_get_commit 'evrone/serverist-email-provider', 'f57c385116139082811442ad48cb6127c29eb351'
    end

    it { should be_pull_request }
    it { should_not be_internal_pull_request }
    it { should be_foreign_pull_request }
    it { should_not be_ignore }
  end

  context "bug_1 pull_request head repo is null" do
    let(:content) { read_json_fixture("github/payload/bug_1_pr_head_repo_is_null") }
    before do
      mock_get_pull_files(repo.full_name, 1109)
      mock_get_commit 'capistrano/capistrano', 'd5f67383592ddce6bfb63d8160b8c3ce30823989'
    end
    it { should be_pull_request }
    it { should be_foreign_pull_request }
    it { should be_ignore }
  end

end
