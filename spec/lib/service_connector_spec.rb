require 'spec_helper'

describe Vx::ServiceConnector do

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

  context "payload" do
    subject { described_class.payload(name, {}) }

    context ":github" do
      let(:name) { :github }
      xit { should be }
    end

    context ":gitlab_v4" do
      let(:name) { :gitlab_v4 }
      xit { should be }
    end

    context ":gitlab_v5" do
      let(:name) { :gitlab_v5 }
      xit { should be }
    end
  end

end
