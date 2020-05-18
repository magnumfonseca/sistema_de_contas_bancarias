class BalanceController < ApplicationController
  before_action :authorize_request

  def index
    render json: { balance: @current_account.balance }
  end
end
