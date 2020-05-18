class TransfersController < ApplicationController
  def create
    begin 
      TransactionService.transfer(
        transfer_params[:source_account_id],
        transfer_params[:destination_account_id],
        transfer_params[:amount]
      ) 

      render status: :created
    rescue ActiveRecord::RecordNotFound => not_found_ex
      render not_found_ex.message,  status: :not_found
    rescue InsufficientFundsException => insufficient_funds_ex
      render "insufficient funds", status: :unprocessable_entity
    end
  end

  private

  def transfer_params
    params.permit(:source_account_id, :destination_account_id, :amount)
  end
end
