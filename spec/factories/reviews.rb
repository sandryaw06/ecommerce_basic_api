# == Schema Information
#
# Table name: reviews
#
#  id          :bigint           not null, primary key
#  starts      :integer
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :review do
    starts { 1 }
    description { "MyString" }
  end
end
