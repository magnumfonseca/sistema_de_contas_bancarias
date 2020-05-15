class AccountsController < ApplicationController
  def create
    account_response = AccountService.find(account_params) || AccountService.open(account_params)

    return head :unprocessable_entity if account_response.nil? 

    render json: account_response
  end

  private

  def account_params
    params.require(:account).permit(:id, :name, :balance)
  end
end
