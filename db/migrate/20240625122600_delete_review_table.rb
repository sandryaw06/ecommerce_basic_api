class DeleteReviewTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :review
  end
end
