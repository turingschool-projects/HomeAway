class AddTotalToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :total, :decimal
  end
end
