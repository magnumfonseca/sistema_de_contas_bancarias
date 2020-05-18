class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.integer :source_account_id
      t.integer :destination_account_id
      t.decimal :amount
      t.integer :kind

      t.timestamps
    end

    add_index :transactions, :source_account_id
    add_index :transactions, :destination_account_id
  end
end
