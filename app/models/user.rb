# == Schema Information
#
# Table name: users
#
#  id                       :bigint           not null, primary key
#  username                 :string
#  first_name               :string
#  last_name                :string
#  date_birth               :date
#  reviews_id               :bigint
#  password_digest          :string
#  recovery_password_digest :string
#  email                    :string           default(""), not null
#  encrypted_password       :string           default(""), not null
#  reset_password_token     :string
#  reset_password_sent_at   :datetime
#  remember_created_at      :datetime
#  jti                      :string           not null
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  # include Devise::JWT::RevocationStrategies::JTIMatcher

  # devise :database_authenticatable, :registerable, :validatable,
  #        :jwt_authenticatable, jwt_revocation_strategy: self
         
  has_many :products
  has_many :categories
  has_many :reviews
  has_many :shopping_carts

  has_secure_password
  # has_secure_password :recovery_password_digest, validations: false
end
