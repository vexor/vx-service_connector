require 'spec_helper'

describe Vx::ServiceConnector::GitlabV5 do

  include GitlabV5WebMocks

  let(:endpoint)  { 'http://example.com' }
  let(:token)     { 'token' }
  let(:repo)      { create :repo }
  let(:gitlab)    { described_class.new endpoint, token }

  subject { gitlab }

  it { should be }

  context "(deploy_keys)" do
    let(:key_name)    { 'me@example.com' }
    let(:public_key)  { 'public key' }
    let(:deploy_keys) { gitlab.deploy_keys(repo) }

    context "all" do
      subject { deploy_keys.all }
      before { mock_deploy_keys  }
      it { should have(2).items }
    end

    context "create" do
      subject { deploy_keys.create key_name, public_key }
      before { mock_add_deploy_key }
      it { should be }
    end

    context "destroy" do
      subject { deploy_keys.destroy key_name }
      before do
        mock_deploy_keys
        mock_delete_deploy_key
      end

      it { should have(1).item }
    end
  end
end
