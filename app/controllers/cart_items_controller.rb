class CartItemsController < ApplicationController
  def create
    item = Item.find(params[:item])
    @cart.add_item(item)
    session[:cart] = @cart.to_h
    flash[:notice] = "You have #{pluralize(@cart.count_of(item), item.title)} in your cart."
    redirect_to root_path
  end

  def update
    item = Item.find(params[:id])
    if params[:decrease]
      @cart.decrease(item)
    elsif params[:increase]
      @cart.increase(item)
    end
    session[:cart] = @cart.to_h
    redirect_to cart_items_path
  end

  def destroy
    item = Item.find(params[:id])
    @cart.remove_item(item)
    session[:cart] = @cart.to_h unless current_user
    redirect_to cart_items_path
  end
end
