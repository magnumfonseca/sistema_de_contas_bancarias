require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:account_id) }
  end

  describe 'callbacks' do
    describe 'set_account_id' do
      context 'new account' do
        it 'sets a ramdon value to account id' do
          account = Account.new
          expect(account.account_id).to_not be_nil
        end

        it 'keeps account_id if it is passed' do
          account_id = 'ramdon'
          account = Account.new(account_id: account_id)
          expect(account.account_id).to eq account_id
        end
      end
    end
  end
end
