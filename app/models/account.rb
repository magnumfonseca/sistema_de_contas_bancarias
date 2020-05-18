class Account < ApplicationRecord
  validates :name, presence: true

    has_many :debits, -> { where(kind: :debit) }, class_name: 'Transaction', primary_key: :id, foreign_key: :source_account_id
    has_many :credits, -> { where(kind: :credit) }, class_name: 'Transaction', primary_key: :id, foreign_key: :destination_account_id

    def balance
      credits.sum(:amount) - debits.sum(:amount)
    end
end
