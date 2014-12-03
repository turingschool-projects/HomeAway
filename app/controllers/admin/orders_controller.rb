class Admin::OrdersController < Admin::BaseAdminController

  def index
    @orders = Order.past_orders
  end

  def show
    @order = Order.find(params[:id])
    @order.update_quantities
  end

end
