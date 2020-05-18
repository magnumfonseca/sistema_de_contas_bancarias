require 'json_web_token'

module AuthHelpers
  def authorization_header(account, headers = {})
    headers['Authorization'] = "Bearer #{JsonWebToken.encode({ id: account.id })}"
    headers
  end
end
