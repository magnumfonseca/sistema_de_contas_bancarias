require 'json_web_token'

module AuthHelpers
  def authorization_header(account_id, headers = {})
    headers['Authorization'] = "Bearer #{JsonWebToken.encode({ id: account_id })}"
    headers
  end
end
