class HostsController < ApplicationController
  def show
    user = User.hosts.find_by(host_slug: params[:slug]) || not_found
    @properties = user.properties
    @categories = Category.all
  end
end
