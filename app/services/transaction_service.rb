class TransactionService
  @logger = Rails.logger

  class << self
    def transfer(source_account_id, destination_account_id, amount)
      value = BigDecimal(amount.to_s)

      return if value.zero?

      Transaction.transaction do
        source_account = find_accont(source_account_id)
        destination_account = find_accont(destination_account_id)

        debit(source_account, destination_account, value)
        credit(source_account, destination_account, value)
      end
    end

    private

    def debit(source_account, destination_account, value)
      return if  source_account == destination_account


      transaction_result = source_account.balance - BigDecimal(value.to_s)

      raise InsufficientFundsException.new("Insufficient funds") if transaction_result < 0

      transaction = generate_transaction(source_account, destination_account, value)
      transaction.debit!

      @logger.info("#{value} debited to account #{source_account.id}")
    end

    def credit(source_account, destination_account, value)
      transaction = generate_transaction(source_account, destination_account, value)
      transaction.credit!


      @logger.info("#{value} credited to account #{destination_account.id}")
    end

    def generate_transaction(source_account, destination_account, value)
      transaction = Transaction.new(
        source_account: source_account,
        destination_account: destination_account,
        amount: value
      )
    end

    def find_accont(account_id)
      Account.find(account_id)
    end
  end
end
