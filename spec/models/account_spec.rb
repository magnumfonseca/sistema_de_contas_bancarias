require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'realtions' do
    it { should have_many(:debits) }
    it { should have_many(:credits) }
  end
end
