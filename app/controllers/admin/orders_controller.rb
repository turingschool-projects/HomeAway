class Admin::OrdersController < Admin::BaseAdminController

  def index
    @orders = Order.past_orders
  end

  def show
    @order = Order.find(params[:id])
    @order.update_quantities
  end

  def ordered
    @orders = Order.ordered
    render :index
  end

  def cancelled
    @orders = Order.cancelled
    render :index
  end

  def paid
    @orders = Order.paid 
    render :index
  end

  def completed
    @orders = Order.completed
    render :index
  end
end
