class Product < ApplicationRecord

    belongs_to :category
    has_many :reviews
    belongs_to :user
    
    validates :name, presence: true, uniqueness: true
    validates :category_id, presence: true
end
