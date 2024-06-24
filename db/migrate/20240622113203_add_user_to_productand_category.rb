class AddUserToProductandCategory < ActiveRecord::Migration[7.1]
  def change

    add_column :products, :user_id, :int
    add_column :categories, :user_id, :int

  end
end
