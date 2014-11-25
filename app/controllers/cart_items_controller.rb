class CartItemsController < ApplicationController

  def create
    item_id = params[:item_id].to_i
    item = Item.find(item_id)
    @cart.add_item(item)
    session[:cart] = @cart.data
    flash[:notice] = "You have #{pluralize(@cart.count_of(item), item.title)} in your cart."
    redirect_to root_path
  end



end
