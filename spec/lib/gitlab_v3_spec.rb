require 'spec_helper'

describe Vx::ServiceConnector::GitlabV3 do

  include GitlabV3Mocks

  let(:endpoint) { 'http://example.com' }
  let(:token)    { 'token' }
  let(:repo)     { create :repo }
  let(:gitlab)   { described_class.new endpoint, token }
  subject { gitlab }

  context "(repos)" do
    subject { gitlab.repos }
    before { mock_repos }
    it { should have(2).item }
    context "values" do
      subject { gitlab.repos.map(&:values) }
      it { should eq(
        [[4, "diaspora/diaspora-client", true,
          "git@example.com:diaspora/diaspora-client.git",
          "http://example.com/diaspora/diaspora-client",
          "description"],
         [6, "brightbox/puppet", true,
          "git@example.com:brightbox/puppet.git",
          "http://example.com/brightbox/puppet",
          "description"]]
      ) }
    end
  end

  context "(deploy_keys)" do
    let(:key_name)    { 'key_name' }
    let(:public_key)  { 'public_key' }
    let(:deploy_keys) { gitlab.deploy_keys(repo) }

    context "all" do
      subject { deploy_keys.all }
      before { mock_deploy_keys }
      it { should have(2).item }
    end

  end
end
