class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :account_id
      t.decimal :balance, default: 0
      t.string :name

      t.timestamps
    end

    add_index :accounts, :account_id, unique: true
  end
end
