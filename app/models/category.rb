class Category < ApplicationRecord
  
  has_many :products
  belongs_to :user
  
  validates :name, uniqueness: true
end
