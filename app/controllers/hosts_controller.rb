class HostsController < ApplicationController
  helper_method :is_the_host?

  def show
    @user = User.find(params[:id])
    if @user.host?
      @properties = Property.active.for_user(@user.id)
      @is_the_host = @user == current_user
    else
      flash[:notice] = "User is no longer a host."
      redirect_to root_path
    end
  end

  def is_the_host?
    @is_the_host
  end
end
