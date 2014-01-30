require 'spec_helper'

describe Vx::ServiceConnector::GitlabV5::Payload do

  include GitlabV5WebMocks

  let(:content) { read_json_fixture("gitlab_v5/payload/push") }
  let(:repo)    { create :repo }
  let(:gitlab)  { Vx::ServiceConnector::GitlabV5.new 'http://example.com', 'token' }
  let(:payload) { gitlab.payload(repo, content) }
  subject { payload }

  context "push" do
    let(:sha) { 'decc3915e29d7ae1786bb981b2ea3702afae592a' }
    let(:url) { "http://git.dev.gorod-skidok.com/serverist2/event_generator/commit/decc3915e29d7ae1786bb981b2ea3702afae592a"  }

    before do
      mock_get_commit 1, sha
    end

    its(:pull_request?)       { should be_false }
    its(:pull_request_number) { should be_nil }
    its(:sha)                 { should eq sha }
    its(:branch)              { should eq 'testing' }
    its(:branch_label)        { should eq 'testing' }
    its(:message)             { should eq 'Replace sanitize with escape once' }
    its(:author)              { should eq 'Dmitriy Zaporozhets' }
    its(:author_email)        { should eq 'dzaporozhets@sphereconsultinginc.com' }
    its(:web_url)             { should eq url }
    its(:ignore?)             { should be_false }
  end

end
