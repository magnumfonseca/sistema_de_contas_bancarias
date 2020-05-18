require 'json_web_token'

class AccountService
  @logger = Rails.logger

  class << self
    def find(account_params)
      account = Account.find_by_id(account_params[:id])

      return nil unless account

      @logger.info("Found a account with #{account.attributes}")

      { id: account.id, token: generate_token(account.id) }
    end

    def open(account_params)
      @logger.info("Creating a account with #{account_params}")

      account = Account.new(id: account_params[:id], name: account_params[:name])

      return nil unless account.save

      TransactionService.transfer(account.id, account.id, account_params[:balance])

      account.attributes.symbolize_keys.merge(token: generate_token(account.id)).merge(balance: account.balance)
    end

    private

    def generate_token(account_id)
      JsonWebToken.encode({ id: account_id })
    end
  end
end
