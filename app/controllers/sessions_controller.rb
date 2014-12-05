class SessionsController < ApplicationController
  def new
    @session = session
  end

  def create
    session[:return_to] ||= request.referer
    user = User.find_by(email_address: params[:email_address])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      convert_cart(user, session)
      flash[:notice] = "Welcome, #{user.name}!"
      user.admin? ? redirect_to(admin_items_path) : redirect_to(root_path)
    else
      flash[:errors] = "Invalid Login"
      redirect_to :back
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
