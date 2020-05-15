require 'rails_helper'

RSpec.describe "Account Create", type: :request do
  describe 'post' do
    let(:account_params) { { id: account_id, name: 'xpto', balance: 10.22 } }

    context 'account alread exists' do 
      let!(:account_id) { rand(1..10) }
      let!(:account) { Account.create(account_params) }

      it 'returns id an token' do
        post '/api/accounts', params: { account: account_params }

        body = JSON.parse(response.body).symbolize_keys

        expect(response).to have_http_status(:success)
        expect(body[:id]).to eq account_id
        expect(body[:token]).to_not be_nil
      end
    end

    context 'account does not exists' do
      context 'with valid params' do
        let!(:account_id) { rand(1..10) }
        it 'returns id an token' do
          post '/api/accounts', params: { account: account_params }

          body = JSON.parse(response.body).symbolize_keys

          expect(response).to have_http_status(:success)
          expect(body[:id]).to eq account_id
          expect(body[:name]).to eq account_params[:name]
          expect(body[:token]).to_not be_nil
        end
      end

      context 'with invalid params' do
        let!(:account_id) { rand(1..10) }
        let(:account_params) { { id: account_id, balance: 10.22 } }

        it '' do
          post '/api/accounts', params: { account: account_params }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
