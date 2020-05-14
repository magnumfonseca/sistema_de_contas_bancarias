class Account < ApplicationRecord
  validates :name, :balance, presence: true
  validates :account_id, uniqueness: { case_sensitive: true }
  after_initialize :set_account_id


  private

  def set_account_id
    self.account_id ||= SecureRandom.hex
  end
end
