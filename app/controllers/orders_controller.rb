class OrdersController < ApplicationController
  def index
    # need to make orders index page with list of this user's past (ie not in_cart) orders
    @orders = current_user.orders.past_orders
  end
  
  def show
    @order = current_user.orders.where(id: params[:id]).take
    if @order
      render :show
    else
      flash[:error] = "You may only view your own orders"
      redirect_to @cart.order
    end
  end

  def update
    order = @cart.order
    order.place! if order.in_cart?
    redirect_to order
  end
end
