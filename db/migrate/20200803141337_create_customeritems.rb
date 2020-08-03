class CreateCustomeritems < ActiveRecord::Migration[5.2]
  def change
    create_table :customeritems do |t|
      t.integer :item_id
      t.integer :customer_id
    end
  end
end
