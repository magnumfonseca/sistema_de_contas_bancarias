require 'json_web_token'

class AccountService
  class << self
    def open(account_params)
      account = Account.find_by_id(account_params[:id])

      return { id: account.id, token: generate_token(account.id) } unless account.nil?

      create_new_account(account_params)
    end

    private

    def create_new_account(account_params)
      puts "Creating a account with #{account_params}"

      account = Account.new(account_params)

      return nil unless account.save

      account.attributes.symbolize_keys.merge(token: generate_token(account.id))
    end

    def generate_token(account_id)
      JsonWebToken.encode({ id: account_id })
    end
  end
end
