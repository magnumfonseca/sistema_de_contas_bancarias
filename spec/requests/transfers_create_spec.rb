require 'rails_helper'

RSpec.describe "/api/transfers", type: :request do
  let(:initial_balance) { 10 }
  let!(:destination) { Account.create(name: 'dest', balance: initial_balance) }
  let!(:source) { Account.create(name: 'source', balance: initial_balance) }
  let(:source_account_id) { source.id }
  let(:destination_account_id) { destination.id }
  let(:amount) { 5.5 }

  describe 'post'do
    subject { post('/api/transfers', params: trasnfer_params) }

    let(:trasnfer_params) do
      {
        source_account_id: source_account_id,
        destination_account_id: destination_account_id,
        amount: amount
      }
    end

    context 'when source account does not exists' do
      let(:source_account_id) { rand(99..999) }

      it 'returns status not found' do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when destination account does not exists' do
      let(:destination_account_id) { rand(99..999) }

      it 'returns status not found' do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when source account does not have enough balance' do
      let(:amount) { 55 }

      it 'returns unprocessable entity' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'transfer succeeds' do
      it 'returns status created' do
        subject
        source.reload
        destination.reload
        expect(response).to have_http_status(:created)
        expect(source.balance).to_not eq initial_balance
        expect(destination.balance).to_not eq initial_balance
      end
    end
  end
end
