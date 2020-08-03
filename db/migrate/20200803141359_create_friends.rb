class CreateFriends < ActiveRecord::Migration[5.2]
  def change
    create_table :friends do |t|
      t.integer :customer_id
      t.integer :cart_id
      t.string :log_in_id
      t.string :name
    end
  end
end
