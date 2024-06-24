FactoryBot.define do
  factory :product do
    name { Faker::Lorem.sentence }
    description { "MyText example" }
  end
end
