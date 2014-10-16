require 'spec_helper'

describe Vx::ServiceConnector::Bitbucket::Payload do

  include BitbucketWebMocks

  let(:content)    { read_json_fixture "bitbucket/payload/push" }
  let(:bitbucket)  { Vx::ServiceConnector::Bitbucket.new 'login', 'token' }
  let(:repo)       { create :repo }
  let(:payload)    { bitbucket.payload repo, content }
  subject { payload }

  context "push" do
    let(:url) { "https://github.com/evrone/ci-worker-test-repo/commit/687753389908e70801dd4ff5448be908642055c6"  }

    # its(:pull_request?)       { should be_false }
    # its(:pull_request_number) { should be_nil }
    # its(:sha)                 { should eq '687753389908e70801dd4ff5448be908642055c6' }
    # its(:branch)              { should eq 'master' }
    # its(:branch_label)        { should eq 'master' }
    # its(:message)             { should eq 'test commit #3' }
    # its(:author)              { should eq 'Dmitry Galinsky' }
    # its(:author_email)        { should eq 'dima.exe@gmail.com' }
    # its(:web_url)             { should eq url }
    # its(:ignore?)             { should be_false }
  end

 

end
