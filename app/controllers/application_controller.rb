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
    @cart = Cart.new(session[:cart])
  end

  before_action :load_cart

end
