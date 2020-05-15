class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.decimal :balance, default: 0.0, precision: 20,  scale: 2
      t.string :name

      t.timestamps
    end
  end
end
