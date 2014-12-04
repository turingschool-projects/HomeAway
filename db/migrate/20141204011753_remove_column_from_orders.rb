class RemoveColumnFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :item_id
  end
end
