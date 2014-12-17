class CartPropertiesController < ApplicationController
  def create
    property = Property.find(params[:property])
    @cart.add_property(property)
    session[:cart] = @cart.to_h
    flash[:notice] = "You have #{pluralize(@cart.count_of(property), property.title)} in your cart."
    redirect_to root_path
  end

  def update
    property = Property.find(params[:id])
    if params[:decrease]
      @cart.decrease(property)
    elsif params[:increase]
      @cart.increase(property)
    end
    session[:cart] = @cart.to_h
    redirect_to cart_properties_path
  end

  def destroy
    property = Property.find(params[:id])
    @cart.remove_property(property)
    session[:cart] = @cart.to_h unless current_user
    redirect_to cart_properties_path
  end
end
