require 'rails_helper'
require 'json_web_token'

RSpec.describe 'JsonWebToken' do
  let(:payload) { { id: '1234567' } }
  context 'encode and decode' do
    it 'should encode a payload and then decode' do
      jwt = JsonWebToken.encode(payload)
      decoded = JsonWebToken.decode(jwt)
      expect(decoded[:id]).to eq(payload[:id])
    end
  end
end
