require 'spec_helper'

describe Vx::ServiceConnector::GitlabV4::Payload do
  let(:content) { read_json_fixture("gitlab_v4/payload/push") }
  let(:payload) { described_class.new content }
  subject { payload }

  context "push" do
    let(:url) { "https://gitlab.example.com/sqerp/commit/4b65377d80364713293df276d7756ff6253eedcd"  }

    its(:pull_request?)       { should be_false }
    its(:pull_request_number) { should be_nil }
    its(:head)                { should eq 'a1dfcca6369dcbd19607c4cc0f932194d8bdf57d' }
    its(:base)                { should eq 'e9f2a24318cf0a08dc2d7b987b9d8484e8c89406' }
    its(:branch)              { should eq 'master' }
    its(:branch_label)        { should eq 'master' }
    its(:url)                 { should eq url }

    its(:pull_request_head_repo_id){ should be_nil }
    its(:pull_request_base_repo_id){ should be_nil }
  end

  context "pull_request" do
  end

  context "tag?" do
  end

  context "closed_pull_request?" do
  end

  context "foreign_pull_request?" do
  end

=begin
  context "ignore?" do
    subject { payload.ignore? }

    context "when pull request" do
      let(:content) { read_json_fixture("github/payload/foreign_pull_request") }
      it {  should be_false}

      context "and is closed" do
        before do
          expect(payload).to receive(:closed_pull_request?) { true }
        end
        it { should be_true }
      end

      context "and same repo" do
        let(:content) { read_json_fixture("github/payload/pull_request") }
        it { should be_true }
      end
    end

    context "when regular commit" do
      it { should be_false }

      context "and deleted branch" do
        before do
          expect(payload).to receive(:head) { '0000000000000000000000000000000000000000'  }
        end
        it { should be_true }
      end

      context "and tag created" do
        before do
          expect(payload).to receive(:tag?) { true }
        end
        it { should be_true }
      end
    end
  end
=end

  context "to_model" do
    subject { payload.to_model }
    it { should be_instance_of(Vx::ServiceConnector::Model::Payload) }

    its(:values) { should eq(
      [false,
       nil,
       "a1dfcca6369dcbd19607c4cc0f932194d8bdf57d",
       "e9f2a24318cf0a08dc2d7b987b9d8484e8c89406",
       "master",
       "master",
       "https://gitlab.example.com/sqerp/commit/4b65377d80364713293df276d7756ff6253eedcd",
       false]
    ) }
  end

end
