class User < ActiveRecord::Migration[7.1]
  def change
    create_table(:user) do |t|
      t.string :username
      t.string :first_name
      t.string :last_name
      t.date :date_birth
      # t.reference :reviews

    end

  


   
  end
end
