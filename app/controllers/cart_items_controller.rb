class CartItemsController < ApplicationController

  def create
    item = Item.find(params[:item_id])
    @cart.add_item(item)
    session[:cart] = @cart.to_h
    flash[:notice] = "You have #{pluralize(@cart.count_of(item), item.title)} in your cart."
    redirect_to root_path
  end

  def destroy
    item = Item.find(params[:id])
    @cart.remove_item(item)
    session[:cart] = @cart.to_h unless current_user
    redirect_to cart_items_path
  end

  private

  def set_item
    item = Item.find(params[:item_id])
  end
end
