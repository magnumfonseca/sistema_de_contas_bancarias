require 'rails_helper'
require 'json_web_token'

RSpec.describe AccountService, type: :service do
  let(:token) { JsonWebToken.encode({ id: account_id }) }

  describe 'find' do
    let!(:account_id) { rand(1..10) }
    let(:account_params) { { id: account_id, name: 'xpto', balance: 10.22 } }
    subject { described_class.find(account_params) }

    context 'with an existing account' do
      let!(:pervious_account) { Account.create(account_params) }

      it 'returns account id and token' do
        response = { id: account_id, token: token } 
        expect(subject).to eq response
      end
    end

    context 'with no existing account' do
      it { is_expected.to be_nil }
    end
  end

  describe 'open' do
    let!(:account_id) { rand(1..10) }
    subject { described_class.open(account_params) }

    context 'with invalid params' do
      let(:account_params) { { id: account_id, balance: 10.22 } }

      it { is_expected.to be_nil }
    end
    context 'with valid params' do
      let(:account_params) { { id: account_id, name: 'xpto', balance: 10.22 } }

      it 'returns account attributes and token' do
        response = account_params.
          merge(token: token, balance: BigDecimal('10.22'))

        expect(subject.except(:updated_at, :created_at)).to eq response
      end
    end
  end
end
