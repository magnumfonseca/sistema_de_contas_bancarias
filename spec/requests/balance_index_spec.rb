require 'rails_helper'

RSpec.describe "Balance", type: :request do
  describe 'get' do
    let(:initial_balance) { 10.50 }
    let!(:account1) { AccountService.open(name: "teste", balance: initial_balance) }
    let!(:account2) { AccountService.open(name: "teste", balance: initial_balance) }

    context 'with no transactions' do
      subject { get("/api/accounts/#{account1[:id]}/balance", headers: authorization_header(account1[:id])) }
      it "returns json" do
        subject
        response_body = JSON.parse(response.body)
        expect(response_body["balance"]).to eq initial_balance.to_s
      end
    end

    context 'after transfer' do
      before do
        TransactionService.transfer(account1[:id], account2[:id], account1[:balance])
      end

      it "returns zero for account1" do
        get("/api/accounts/#{account1[:id]}/balance", headers: authorization_header(account1[:id]))
        response_body = JSON.parse(response.body)
        expect(response_body["balance"]).to eq "0.0"
      end

      it "do not return zero for account1" do
        get("/api/accounts/#{account2[:id]}/balance", headers: authorization_header(account2[:id]))
        response_body = JSON.parse(response.body)
        expect(response_body["balance"]).to eq((initial_balance * 2).to_s)
      end
    end
  end
end
