class HostsController < ApplicationController  
  helper_method :is_the_host_or_partner?

  def show
    @user = User.find(params[:id])
    if @user.host?
      @properties = Rails.cache.fetch("all_hosts_properties") do
        Property.active.for_user(@user.id).paginate(:page => params[:page], :per_page => 6)
      end

      is_the_host_or_partner?
      if request.xhr?
        render partial: "partials/listings"
      end
    else
      flash[:notice] = "User is no longer a host."
      redirect_to root_path
    end
  end

  def is_the_host_or_partner?
    @host_or_partner ||= current_user && (@user == current_user || @user.partners.include?(current_user))
  end
end
