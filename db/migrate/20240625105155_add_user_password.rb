class AddUserPassword < ActiveRecord::Migration[7.1]
  rename_table :user, :users
  def change

    add_column :users, :password_digest, :string
    add_column :users, :recovery_password_digest, :string
  end
end
