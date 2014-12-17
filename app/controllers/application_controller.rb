class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  include ActionView::Helpers::TextHelper

  def current_user
    @current_user ||= if session[:user_id]
      user = User.where(id: session[:user_id]).first
      session[:user_id] = nil unless user
      user
    end
  end

  def load_cart
    if current_user
      reservation = Reservation.where(id: session[:reservation_id]).where(status: "in_cart").take
      reservation ||= Reservation.create!(user: current_user, status: "in_cart")
      session[:reservation_id] = reservation.id unless session[:reservation_id] == reservation.id
      @cart = ReservationCart.new(reservation)
    else
      @cart = Cart.new(session[:cart])
    end
  end

  def require_admin
    unless current_user && current_user.admin?
      flash[:notice] = "Unauthorized"
      redirect_to root_path
    end
  end

  # Do we still want to do this?
  # before_action :load_cart

end
