require 'rails_helper'
require 'json_web_token'

RSpec.describe AccountService, type: :service do
  describe 'open' do
    subject { described_class.open(account_params) }

    context 'with invalid params' do
      let(:account_params) { { id: 1, balance: 10.22 } }

      it { is_expected.to be_nil }
    end
    context 'with valid params' do
      let(:account_params) { { id: 1, name: 'xpto', balance: 10.22 } }
      let(:token) { JsonWebToken.encode({ id: 1 }) }

      context 'with an previous created account' do
        let!(:pervious_account) { Account.create(account_params) }

        it 'returns account id and token' do
          response = { id: 1, token: token } 

          expect(subject).to eq response
        end
      end

      context 'without an previous created account' do
        it 'returns account attributes and token' do
          response = account_params.
            merge(token: token, balance: BigDecimal('10.22'))

          expect(subject.except(:updated_at, :created_at)).to eq response
        end
      end
    end
  end
end
