# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :string
#  category_id :bigint
#  user_id     :integer
#  code        :string
#  stock       :integer          default(0)
#  price       :integer          default(0)
#
FactoryBot.define do
  factory :product do
    name { Faker::Lorem.sentence }
    description { "MyText example" }
  end
end
