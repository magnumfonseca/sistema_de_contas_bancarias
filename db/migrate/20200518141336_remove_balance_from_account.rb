class RemoveBalanceFromAccount < ActiveRecord::Migration[6.0]
  def change
    remove_column :accounts, :balance, :decimal
  end
end
