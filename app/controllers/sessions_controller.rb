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
      redirect_to :back
      #user.admin? ? redirect_to(admin_properties_path) : redirect_to(root_path)
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
    return if session[:reservation_id] || !session[:cart].present?
    reservation = CartReservationConverter.convert(@cart.to_h, user)
    session[:reservation_id] = reservation.id
    session[:cart] = nil
  end
end
