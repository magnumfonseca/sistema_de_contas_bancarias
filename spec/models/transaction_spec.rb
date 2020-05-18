require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:source_account_id) }
    it { should validate_presence_of(:destination_account_id) }
    it { should validate_presence_of(:amount) }
  end

  describe 'realtions' do
    it { should belong_to(:source_account) }
    it { should belong_to(:destination_account) }
  end
end
