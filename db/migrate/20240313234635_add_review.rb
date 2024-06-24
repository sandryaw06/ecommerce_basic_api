class AddReview < ActiveRecord::Migration[7.1]
  def change
    create_table(:review) do |t|
      
      t.string :title
      t.text :body
      t.string :timestamp

    end

    add_reference(:user, :reviews)

  end
end
