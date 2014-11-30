class OrdersController < ApplicationController
  def update
    order = @cart.order
    order.place! if order.in_cart?
    redirect_to order
  end
end
