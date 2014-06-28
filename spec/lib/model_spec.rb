require 'spec_helper'

describe "(models)" do
  context Vx::ServiceConnector::Model::Payload do
    let(:params) { Vx::ServiceConnector::Model.test_payload_attributes }

    it "should build from hash" do
      payload = described_class.from_hash(params).to_hash
      expect(payload).to eq params
    end

    it "should knowns [ci skip]" do
      params[:skip] = false
      payload = described_class.from_hash(params)
      expect(payload).to_not be_ignore

      params[:skip] = true
      payload = described_class.from_hash(params)
      expect(payload).to be_ignore

      params[:skip] = false
      params[:message] = 'message [ci skip]'
      payload = described_class.from_hash(params)
      expect(payload).to be_ignore
    end

  end
end
