class SessionsController < ApplicationController
  def new
  end

  def create
    session[:return_to] ||= request.referer
    user = User.find_by(email_address: params[:email_address])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      convert_cart(user, session)
      user.admin? ? redirect_to(admin_items_path) : redirect_to(session.delete(:return_to))
    else
      flash[:errors] = "Invalid Login"
      render :new
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end

  private
  def convert_cart(user, session)
    return if session[:order_id] || !session[:cart].present?
    order = CartOrderConverter.convert(@cart.to_h, user)
    session[:order_id] = order.id
    session[:cart] = nil
  end
end
