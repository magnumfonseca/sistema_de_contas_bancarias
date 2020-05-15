class AccountController < ApplicationController
  def create
    account_response = AccountService.open(account_params)

    return head :unprocessable_entity if account.nil? 

    render json: account_response
  end

  private

  def account_params
    params.require(:account).permit(:account_id, :name, :balance)
  end
end
