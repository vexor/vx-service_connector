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
    subject { described_class.to(name).to_s }

    context ":github" do
      let(:name) { :github }
      it { should be_include("Github") }
    end

    context ":gitlab_v4" do
      let(:name) { :gitlab_v4 }
      it { should be_include("GitlabV4") }
    end

    context ":gitlab_v5" do
      let(:name) { :gitlab_v5 }
      it { should be_include("GitlabV5") }
    end
  end

end
