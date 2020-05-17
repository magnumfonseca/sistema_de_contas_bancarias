class Transaction < ApplicationRecord
  enum kind: [:debit, :credit]

  validates :source_account_id, :destination_account_id, :amount, presence: true

  belongs_to :source_account, class_name:  "Account", primary_key: :id,  foreign_key: :source_account_id
  belongs_to :destination_account, class_name:  "Account", primary_key: :id, foreign_key: :destination_account_id
end
