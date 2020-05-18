class TransactionService
  class << self
    def transfer(source_account_id, destination_account_id, amount)
      Transaction.transaction do
        source_account = find_accont(source_account_id)
        destination_account = find_accont(destination_account_id)

        debit(source_account, destination_account, amount)
        credit(source_account, destination_account, amount)
      end
    end

    private

    def debit(source_account, destination_account, amount)
      return if  source_account == destination_account

      transaction_result = source_account.balance - BigDecimal(amount.to_s)

      raise InsufficientFundsException.new if transaction_result < 0

      transaction = generate_transaction(source_account, destination_account, amount)
      transaction.debit!

      source_account.update(balance: transaction_result) 
    end

    def credit(source_account, destination_account, amount)
      transaction_result = destination_account.balance + BigDecimal(amount.to_s)

      transaction = generate_transaction(source_account, destination_account, amount)
      transaction.credit!

      destination_account.update(balance: transaction_result)
    end

    def generate_transaction(source_account, destination_account, amount)
      transaction = Transaction.new(
        source_account: source_account,
        destination_account: destination_account,
        amount: amount
      )
    end

    def find_accont(account_id)
      Account.find(account_id)
    end
  end
end
