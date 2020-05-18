class TransfersController < ApplicationController
  before_action :authorize_request

  def create
    if transfer_params[:source_account_id] != @current_account.id.to_s
      render status: :unauthorized 
    else
      begin
        TransactionService.transfer(
          transfer_params[:source_account_id],
          transfer_params[:destination_account_id],
          transfer_params[:amount]
        ) 

        render status: :created
      rescue ActiveRecord::RecordNotFound => not_found_ex
        render json: { errors: not_found_ex.message},  status: :not_found
      rescue InsufficientFundsException => insufficient_funds_ex
        render json: { errors: insufficient_funds_ex.message }, status: :unprocessable_entity
      end
    end
  end

  private

  def transfer_params
    params.permit(:source_account_id, :destination_account_id, :amount)
  end
end
