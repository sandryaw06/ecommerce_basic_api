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
require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
