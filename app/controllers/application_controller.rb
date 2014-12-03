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
      order = Order.where(id: session[:order_id]).take
      order ||= Order.find_or_create_by(user: current_user, status: "in_cart")
      session[:order_id] = order.id unless session[:order_id] == order.id
      @cart = OrderCart.new(order)
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

  before_action :load_cart

end
