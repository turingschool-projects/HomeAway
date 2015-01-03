class HostsController < ApplicationController
  helper_method :is_the_host?

  def show
    user = User.hosts.find(params[:id])
    @properties = Property.active.for_user(user.id)
    @is_the_host = user == current_user
  end

  def is_the_host?
    @is_the_host
  end
end
