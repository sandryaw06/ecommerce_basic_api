class ShoppingCartProduct < ApplicationRecord
  belongs_to :shopping_cart
  belongs_to :products
end
