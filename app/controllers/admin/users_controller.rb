class Admin::UsersController < Admin::BaseAdminController
  def index
    @users = User.all
  end

  def retire
    user = User.find params[:id]
    user.update_attribute :host, false
    user.retire_listings
    redirect_to admin_users_path
  end
end
