class CartController < ApplicationController
  def show
  end

  def update
    property = Property.find(params[:id])
    redirect_to :back
  end

  def destroy
    @cart.clear
    redirect_to cart_path
  end
end
