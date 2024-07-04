class ChangeProdAttr < ActiveRecord::Migration[7.1]
  def change
    change_column_default(:products, :stock, 0)
  end
end
