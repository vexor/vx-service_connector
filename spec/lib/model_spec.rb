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

    context 'perform? strategy' do
      let(:params_issue)       { params.merge branch: 'issue-141' }
      let(:params_some_branch) { params.merge branch: 'some-branch' }
      let(:params_internal_pr) { params.merge internal_pull_request?: true }
      let(:params_foreign_pr)  { params.merge foreign_pull_request?: true }

      let(:expectation) do 
        ->(p) { described_class.from_hash(p).perform?(strategy) }
      end

      context 'with branches and prs' do
        let(:strategy) do 
          { branches: 'staging|issue-\d+', 
            pull_requests: false }
        end

        it 'gets performed when branch matches' do
          expect(expectation[params_issue]).to be_true
        end

        it 'doesn\'t get performed when branch doesn\'t match' do
          expect(expectation[params_some_branch]).to be_false
        end

        it 'doesn\'t get performed if it\'s an internal pull' do
          expect(expectation[params_internal_pr]).to be_false
        end

        it 'doesn\'t get performed if it\'s an extermal pull' do
          expect(expectation[params_foreign_pr]).to be_false
        end

        it 'doesn\'t get performed if it\'s a pull and branch matches' do
          e = expectation[params_issue.merge internal_pull_request?: true]
          expect(e).to be_false
        end
      end

      context 'with branches' do
        let(:strategy) do 
          { branches: 'staging|issue-\d+|master' } # pr == true by default
        end

        it 'gets performed when branch matches' do
          expect(expectation[params_issue]).to be_true
        end

        it 'doesn\'t get performed when branch doesn\'t match' do
          expect(expectation[params_some_branch]).to be_false
        end

        it 'gets performed if it\'s an internal pull' do
          expect(expectation[params_internal_pr]).to be_true
        end

        it 'gets performed if it\'s an extermal pull' do
          expect(expectation[params_foreign_pr]).to be_true
        end

        it 'gets performed if it\'s a pull and branch matches' do
          e = expectation[params_issue.merge internal_pull_request?: true]
          expect(e).to be_true
        end
      end

      context 'with prs' do
        let(:strategy) do 
          { pull_requests: false } # all branches by default
        end

        it 'gets performed with one branch' do
          expect(expectation[params_issue]).to be_true
        end

        it 'gets performed with another branch' do
          expect(expectation[params_some_branch]).to be_true
        end

        it 'doesn\'s get performed if it\'s an internal pull' do
          expect(expectation[params_internal_pr]).to be_false
        end

        it 'doesn\'t get performed if it\'s an extermal pull' do
          expect(expectation[params_foreign_pr]).to be_false
        end
      end
    end
  end
end
