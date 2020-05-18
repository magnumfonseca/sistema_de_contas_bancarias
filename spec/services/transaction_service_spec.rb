require 'rails_helper'

RSpec.describe TransactionService, type: :service do
  describe 'transfer' do
    subject { described_class.transfer(source_account_id, destination_account_id, amount) }
    let(:amount) { 10.0 }

    context 'when source_account does not exists' do
      let!(:destination) { Account.create(name: 'dest', balance: 10) }
      let(:source_account_id) { rand(99..1000) }
      let(:destination_account_id) { destination.id }

      it 'raises error' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when destination_account does not exists' do
      let!(:source_account) { Account.create(name: 'source', balance: 10) }
      let(:destination_account_id) { rand(99..1000) }
      let(:source_account_id) { source_account.id }

      it 'raises error' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when source account has not enough balance' do
      context 'when source_account is different from destination account' do
        let!(:destination) { Account.create(name: 'dest', balance: 10) }
        let!(:source_account) { Account.create(name: 'source', balance: 5) }

        let(:source_account_id) { source_account.id }
        let(:destination_account_id) { destination.id }

        it 'raises error' do
          expect { subject }.to raise_error(InsufficientFundsException)
        end
      end

      context 'when source_account and destination are the same' do
        let!(:source_account) { Account.create(name: 'source', balance: balance) }
        let(:balance) { 5 }
        let(:source_account_id) { source_account.id }
        let(:destination_account_id) { source_account.id }
        let(:result_balance) { BigDecimal( (balance + amount).to_s ) }

        before do
          subject
          source_account.reload
        end 

        it 'executes a transaction and add balance to source_account' do
          transaction = Transaction.last

          expect(Transaction.count).to eq 1
          expect(transaction.source_account_id).to eq source_account.id 
          expect(transaction.destination_account_id).to eq source_account.id 
          expect(source_account.balance).to eq(result_balance)
          expect(transaction.credit?).to be_truthy
        end
      end
    end

    context 'when source_account has enough balance' do
      context 'when source_account is different from destination' do
        let!(:source_account) { Account.create(name: 'source', balance: 15) }
        let!(:destination_account) { Account.create(name: 'dest', balance: 10) }

        let(:source_account_id) { source_account.id }
        let(:destination_account_id) { destination_account.id }
        let!(:result_source_balance) { BigDecimal( (source_account.balance - amount).to_s ) }
        let!(:result_destination_balance) { BigDecimal( (destination_account.balance + amount).to_s ) }

        before do
          subject

          source_account.reload
          destination_account.reload
        end

        it 'transfer from source to destination' do
          debit = Transaction.debit.last
          credit = Transaction.credit.last

          expect(Transaction.count).to eq 2
          expect(source_account.balance).to eq result_source_balance
          expect(destination_account.balance).to eq result_destination_balance
          expect(debit.source_account).to eq source_account
          expect(debit.destination_account).to eq destination_account
          expect(debit.amount).to eq amount
          expect(credit.source_account).to eq source_account
          expect(credit.destination_account).to eq destination_account
          expect(credit.amount).to eq amount
        end
      end
    end
  end
end
