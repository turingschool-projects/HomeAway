class Admin::UsersController < Admin::BaseAdminController
  def index
    @users = User.all
  end
end
