class HostsController < ApplicationController
  helper_method :is_the_host?
  def show
    user = User.hosts.find_by(host_slug: params[:slug]) || not_found
    @properties = Property.active.for_user(user.id)
    @is_the_host = user == current_user
  end

  def is_the_host?
    @is_the_host
  end
end
