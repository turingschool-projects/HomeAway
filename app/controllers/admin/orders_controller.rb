class Admin::OrdersController < Admin::BaseAdminController
  before_action :set_order, except: [:index, :completed, :ordered, :cancelled, :paid]

  def index
    @orders = Order.past_orders
  end

  def update
    if params[:decrease]
      item = Item.find(params[:decrease])
      @order.decrease(item)
    elsif params[:increase]
      item = Item.find(params[:increase])
      @order.increase(item)
    end
    redirect_to admin_order_path(@order)
  end

  def destroy
    item = Item.find(params[:remove])
    @order.remove_item(item)
    redirect_to admin_order_path(@order)
  end

  def show
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
    @order.pay!
    redirect_to admin_orders_path
  end

  def complete
    @order.complete!
    redirect_to admin_orders_path
  end

  def cancel
    @order.cancel!
    redirect_to admin_orders_path
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end
