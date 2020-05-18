require 'rails_helper'

RSpec.describe TransactionService, type: :service do
  describe 'transfer' do
    subject { described_class.transfer(source_account_id, destination_account_id, amount) }
    let(:amount) { 10.0 }

    context 'when source_account does not exists' do
      let!(:destination) { Account.create(name: 'dest') }
      let(:source_account_id) { rand(99..1000) }
      let(:destination_account_id) { destination.id }

      it 'raises error' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when destination_account does not exists' do
      let!(:source_account) { Account.create(name: 'source') }
      let(:destination_account_id) { rand(99..1000) }
      let(:source_account_id) { source_account.id }

      it 'raises error' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when source account has not enough balance' do
      context 'when source_account is different from destination account' do
        let!(:destination) { Account.create(name: 'dest') }
        let!(:source_account) { Account.create(name: 'source') }

        let(:source_account_id) { source_account.id }
        let(:destination_account_id) { destination.id }

        it 'raises error' do
          expect { subject }.to raise_error(InsufficientFundsException)
        end
      end

      context 'when source_account and destination are the same' do
        let!(:source_account) { Account.create(name: 'source') }
        let(:source_account_id) { source_account.id }
        let(:destination_account_id) { source_account.id }
        let(:result_balance) { BigDecimal(amount.to_s) }

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

    context 'when amount is zero' do
        let!(:source_account) { Account.create(name: 'source') }
        let!(:destination_account) { Account.create(name: 'dest') }

        let(:source_account_id) { source_account.id }
        let(:destination_account_id) { destination_account.id }
        let(:amount) { 0.0 }

        it 'does not transfer' do
          subject

          expect(source_account.balance).to be_zero
          expect(destination_account.balance).to be_zero
          expect(Transaction.count).to be_zero
        end
    end

    context 'when source_account has enough balance' do
      context 'when source_account is different from destination' do
        let!(:source_account) { Account.create(name: 'source') }
        let!(:destination_account) { Account.create(name: 'dest') }

        let(:source_account_id) { source_account.id }
        let(:destination_account_id) { destination_account.id }
        let(:source_initial_balance) { 15 }
        let(:destination_initial_balance) { 10 }

        before do
          Transaction.create(
            source_account_id: source_account.id,
            destination_account_id: source_account.id,
            amount: source_initial_balance,
            kind: Transaction.kinds[:credit]
          )

          Transaction.create(
            source_account_id: destination_account.id,
            destination_account_id: destination_account.id,
            amount: destination_initial_balance,
            kind: Transaction.kinds[:credit]
          )

          subject
        end

        it 'transfer from source to destination' do
          debit = Transaction.debit.last
          credit = Transaction.credit.last

          expect(source_account.balance).to eq(source_initial_balance - amount)
          expect(destination_account.balance).to eq(destination_initial_balance + amount)
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
