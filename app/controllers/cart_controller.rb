class CartController < ApplicationController
  def show
  end

  def update
    @cart.add_property params[:property].merge(property_id: params[:id])
    redirect_to cart_path
  end

  def destroy
    @cart.clear
    redirect_to cart_path
  end
end
