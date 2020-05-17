class Account < ApplicationRecord
  validates :name, :balance, presence: true

    has_many :debits, -> { where(type: :debit) }, class_name: 'Transaction', primary_key: :id, foreign_key: :source_account_id
    has_many :credits, -> { where(type: :credit) }, class_name: 'Transaction', primary_key: :id, foreign_key: :destination_account_id
end
