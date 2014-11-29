class Admin::BaseAdminController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :require_admin

  layout 'admin'

  protected

  def require_admin
    unless current_user && current_user.admin?
      flash[:notice] = "Unauthorized"
      redirect_to root_path
    end
  end
end
