class CartController < ApplicationController
  def show
    if @cart.property
      @host = @cart.property.user
    else
      @host = nil
    end
  end

  def update
    if @cart.valid_dates?(params[:property][:reservation], params[:id])
      @cart.add_property params[:property].merge(property_id: params[:id])
      redirect_to cart_path
    else
      flash[:errors] = "Invalid dates, select a different date range."
      redirect_to :back
    end
  end

  def destroy
    @cart.clear
    redirect_to properties_path
  end
end
