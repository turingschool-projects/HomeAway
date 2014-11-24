class Admin::BaseAdminController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :require_admin
  helper_method :current_user

  layout 'admin'

  protected

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_admin
    unless current_user && current_user.admin?
      flash[:notice] = "Unauthorized"
      redirect_to root_path
    end
  end
end
