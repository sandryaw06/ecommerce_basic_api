class TablesAttributes < ActiveRecord::Migration[7.1]
  create_table :articles do |t|
    t.column :title,     :string
    t.column :description,  :string
  end


  create_table :products do |t|
    t.column :name,     :string
    t.column :description,  :string
    t.references :category
  end


end
