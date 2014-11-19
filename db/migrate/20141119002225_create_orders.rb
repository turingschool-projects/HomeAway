class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.boolean :delivery
      t.string :address
      t.string :status, default: "ordered"
      t.integer :user_id
      t.integer :item_id

      t.timestamps
    end
  end
end
