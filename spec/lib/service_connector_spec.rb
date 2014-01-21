require 'spec_helper'

describe Vx::ServiceConnector do

  context ".payload" do
    subject { described_class.payload type, params }

    context ":github" do
      let(:type)   { :github }
      let(:params) { read_json_fixture("github/payload/push") }
      it { should be }
      it { should be_an_instance_of(Vx::ServiceConnector::Model::Payload) }
    end
  end

  context "to" do
    subject { described_class.to name }

    context ":github" do
      let(:name) { :github }
      it { should be }
    end

    context ":gitlab_v3" do
      let(:name) { :gitlab_v3 }
      it { should be }
    end
  end

end
