class Admin::OrdersController < Admin::BaseAdminController

  def index
    @orders = Order.past_orders
  end

  def update
    @order = Order.find(params[:id])
    if params[:decrease]
      item = Item.find(params[:decrease])
      @order.decrease(item)
    elsif params[:increase]
      item = Item.find(params[:increase])
      @order.increase(item)
    end
    redirect_to admin_order_path(@order)
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

  def pay
    order = Order.find(params[:id])
    order.pay!
    redirect_to admin_orders_path
  end

  def complete
    order = Order.find(params[:id])
    order.complete!
    redirect_to admin_orders_path
  end

  def cancel
    order = Order.find(params[:id])
    order.cancel!
    redirect_to admin_orders_path
  end

end
