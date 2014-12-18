class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  include ActionView::Helpers::TextHelper

  before_action :load_cart
  before_action :create_user_for_sign_up
  after_action  :save_cart

  def current_user
    @current_user ||= if session[:user_id]
      user = User.where(id: session[:user_id]).first
      session[:user_id] = nil unless user
      user
    end
  end

  def load_cart
    @cart = Cart.new session[:cart]
  end

  def save_cart
    session[:cart] = @cart.to_h
  end

  def require_admin
    unless current_user && current_user.admin?
      flash[:notice] = "Unauthorized"
      redirect_to root_path
    end
  end

  def create_user_for_sign_up
    @user = User.new
  end

end
