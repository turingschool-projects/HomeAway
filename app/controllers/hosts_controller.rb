class HostsController < ApplicationController
  def show
    user = User.hosts.find_by(host_slug: params[:slug]) || not_found
    @properties = Property.active.for_user(user.id)
  end
end
