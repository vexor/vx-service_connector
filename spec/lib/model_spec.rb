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
      expect(payload).to be_perform

      params[:skip] = true
      payload = described_class.from_hash(params)
      expect(payload).to_not be_perform

      params[:skip] = false
      params[:message] = 'message [ci skip]'
      payload = described_class.from_hash(params)
      expect(payload).to_not be_perform
    end

    context "perform?" do

      it "message contains [ci skip]" do
        params.merge!(message: "me [ci skip]")

        # always skip
        instance(params).to_not be_perform(nil)
      end

      it "restriction is null" do
        # pass, push to master
        instance(params).to be_perform(nil)

        # pass, foreign pr
        instance(
          params.merge(foreign_pull_request?: true)
        ).to be_perform(nil)

        # deny, internal pr
        instance(
          params.merge(internal_pull_request?: true)
        ).to_not be_perform(nil)
      end

      it "restriction is hash" do
        # pass, branch matched
        instance(
          params.merge(branch: "master")
        ).to be_perform(branch: "(master)" )

        # deny, branch not matched
        instance(
          params.merge(branch: "master")
        ).to_not be_perform(branch: "(develop)" )

        # pass, pr allowed
        instance(
          params.merge(foreign_pull_request?: true)
        ).to be_perform(pull_request: true)

        # pass, pr allowed
        instance(
          params.merge(internal_pull_request?: true)
        ).to be_perform(pull_request: true)

        # deny, pr not allowed
        instance(
          params.merge(foreign_pull_request?: true)
        ).to_not be_perform(pull_request: false)

        # deny, pr not allowed
        instance(
          params.merge(internal_pull_request?: true)
        ).to_not be_perform(pull_request: false)
      end

      it "unknown restriction" do
        # deny always
        instance(params).to_not be_perform('string')
        instance(params).to_not be_perform(['array'])
      end

      def instance(payload)
        expect(described_class.from_hash(payload))
      end

    end
  end
end
