require 'spec_helper'

describe Vx::ServiceConnector::GitlabV3 do

  include GitlabV3Mocks

  let(:endpoint) { 'http://example.com' }
  let(:token)    { 'token' }
  let(:gitlab)   { described_class.new endpoint, token }
  subject { gitlab }

  context "(repos)" do
    subject { gitlab.repos }
    before { mock_repos }
    it { should have(2).item }
    context "values" do
      subject { gitlab.repos.map(&:values) }
      it do
        should eq(
          [[4, "diaspora/diaspora-client", true,
            "git@example.com:diaspora/diaspora-client.git",
            "http://example.com/diaspora/diaspora-client"],
           [6, "brightbox/puppet", true,
            "git@example.com:brightbox/puppet.git",
            "http://example.com/brightbox/puppet"]]
        )
      end
    end

  end
end
