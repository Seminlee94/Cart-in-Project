class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.string :log_in_id
      t.string :log_in_password
      t.integer :cart_id
      t.string :name
      t.string :address
      t.string :friend
    end
  end
end
