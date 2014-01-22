require 'spec_helper'

describe "(models)" do
  context Vx::ServiceConnector::Model::Payload do
    let(:values)  {
      [false, nil, 'head', 'base', 'master', 'master:label',
       'http://example.com', false]
    }
    let(:payload) { described_class.new(*values) }
    subject { payload }

    it { should be }
    its(:values) { should eq values }

    context "to_hash" do
      subject { payload.to_hash }
      it { should eq({
        :base                => "base",
        :branch              => "master",
        :branch_label        => "master:label",
        :head                => "head",
        :ignore?             => false,
        :pull_request?       => false,
        :pull_request_number => nil,
        :url                 => "http://example.com"
      }) }
    end

    context ".from_hash" do
      let(:params) { payload.to_hash }
      let(:new_payload) { described_class.from_hash params }
      subject { new_payload }

      its(:values) { should eq payload.values }
    end
  end
end
