# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
class Category < ApplicationRecord
  
  has_many :products
  belongs_to :user
  
  validates :name, uniqueness: true
end
