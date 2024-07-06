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
class Product < ApplicationRecord

    #save
    before_save :validate_product
    after_save :send_notification
    after_save :push_notification, if: :discount

    belongs_to :category
    has_many :reviews
    belongs_to :user
    
    # validates :price, length: {minimum:1, maximum:3}
    validates :price, length: { in: 1..3, message: "the price is outside the range"}, if: :has_price?
    validates :name, 
        presence:  {message: "the name is a mandatory parameter"}, 
        uniqueness: {message: "the name %{value} already exists"}
    validates :category_id, presence: {message: "it is needed define a category"}
    validates :code, uniqueness: {message: "the code %{value} should be unique"}

    #own validations
    validate :code_validations

    def code_validations
        if !self.code.nil? && self.code.length > 4
            self.errors.add(:code, "The code should have btw 1 and 3 digits")
        end 
    
    end

    def total
      self.price / 100
    end
 
    def discount
        self.total < 5
    end

    def has_price?
        !self.price.nil? && self.price > 0
    end
    private

   

    def validate_product
        puts "\n\n\n>>> Un nuevo product se almacenara!!!"
    end

    def send_notification
        puts "\n\n\n>>> Un nuevo product fue added #{self.name} - #{self.total}"
    end

    #price < 5
    def push_notification
        puts "\n\n\n>>> Nuevo descuento disponible #{self.name}"
    end

    
end
