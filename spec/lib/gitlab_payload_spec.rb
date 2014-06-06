require 'spec_helper'

[6].each do |version|
  gitlab_version = "GitlabV#{version}"
  describe Vx::ServiceConnector.const_get(gitlab_version)::Payload do

    include const_get("#{gitlab_version}WebMocks")

    let(:content) { read_json_fixture("gitlab_v#{version}/payload/push") }
    let(:repo)    { create :repo }
    let(:gitlab)  { Vx::ServiceConnector.const_get(gitlab_version).new 'http://example.com', 'token' }
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
end
