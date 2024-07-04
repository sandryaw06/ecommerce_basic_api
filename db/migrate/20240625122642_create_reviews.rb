class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.integer :starts
      t.string :description

      t.timestamps
    end
  end
end
