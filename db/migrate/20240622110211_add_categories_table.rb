class AddCategoriesTable < ActiveRecord::Migration[7.1]
  def change

    create_table :categories do |t|
      t.column :name, :string
    
      t.timestamps
    end
    
  end
end
