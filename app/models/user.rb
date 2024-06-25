class User < ApplicationRecord
  has_many :products
  has_many :categories

  has_secure_password
  has_secure_password :recovery_password_digest, validations: false
end