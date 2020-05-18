require 'jwt'

class JsonWebToken
  class << self
    def encode(payload, exp = 24.hours.from_now)
      JWT.encode(payload, ENV['JWT_SECRET'])
    end

    def decode(token)
      body = JWT.decode(token, ENV['JWT_SECRET'])[0]
      HashWithIndifferentAccess.new body
    rescue
      nil
    end
  end
end
