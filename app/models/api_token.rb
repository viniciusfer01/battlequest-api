class ApiToken < ApplicationRecord
  # before_create :generate_token
  has_secure_token

  # private

  # def generate_token
  #   self.token = SecureRandom.hex(16) if token.blank?
  # end
end
