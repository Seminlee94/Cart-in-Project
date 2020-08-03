class CreateCarts < ActiveRecord::Migration[5.2]
  def change
    create_table :carts do |t|
      t.string :name_of_store
      t.integer :cart_number
    end
  end
end
