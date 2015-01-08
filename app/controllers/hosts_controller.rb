class HostsController < ApplicationController
  helper_method :is_the_host_or_partner?

  def show
    @user = User.find(params[:id])
    if @user.host?
      @properties = Property.active.for_user(@user.id)
      is_the_host_or_partner?
    else
      flash[:notice] = "User is no longer a host."
      redirect_to root_path
    end
  end

  def is_the_host_or_partner?
    @host_or_partner ||= current_user && (@user == current_user || @user.partners.include?(current_user))
  end
end
