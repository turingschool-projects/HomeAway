class ChangeStatusInOrders < ActiveRecord::Migration
  def change
    change_column_default :orders, :status, :in_cart
  end
end
