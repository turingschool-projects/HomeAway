class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :current_user_is_host, :current_user_is_admin

  include ActionView::Helpers::TextHelper

  before_action :load_cart
  before_action :create_user_for_sign_up
  before_action :clean_session
  after_action  :save_cart

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def current_user_is_host
    current_user && current_user.host?
  end

  def current_user_is_admin
    current_user && current_user.admin?
  end

  def clean_session
    session[:user_id] = nil unless current_user
  end

  def load_cart
    @cart = Cart.new session[:cart]
  end

  def save_cart
    session[:cart] = @cart.to_h
  end

  def require_admin
    unless current_user_is_admin
      flash[:notice] = "Unauthorized"
      redirect_to root_path
    end
  end

  def create_user_for_sign_up
    @user = User.new
  end
end
