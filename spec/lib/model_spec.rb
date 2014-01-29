require 'spec_helper'

describe "(models)" do
  context Vx::ServiceConnector::Model::Payload do

    context ".from_hash" do
      let(:params) { Vx::ServiceConnector::Model.test_payload_attributes }
      subject { described_class.from_hash(params).to_hash }
      it { should eq params }
    end
  end
end
