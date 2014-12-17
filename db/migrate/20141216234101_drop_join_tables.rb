class DropJoinTables < ActiveRecord::Migration
  def change
    drop_table :item_categories
    drop_table :order_items
  end
end
