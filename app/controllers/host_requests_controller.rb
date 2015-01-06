class HostRequestsController < ApplicationController

  def new
    if current_user.try(:host?)
      flash[:notice] = "You're already a host!"
      redirect_to root_path
    else
      @host_request = HostRequest.new
    end
  end

  def create
    @host_request = HostRequest.new(host_request_params)
    if @host_request.save
      flash[:notice] = "Request for host sign up sent!"
      redirect_to user_path(current_user)
    else
      flash[:errors] = "Invalid Sign-up. #{@host_request.errors.full_messages}"
      redirect_to :back
    end
  end

  def destroy
    require_admin
    HostRequest.find(params[:id]).try(:delete)
    redirect_to user_path(current_user)
  end

  private
  def host_request_params
    { user: current_user, message: params[:host_request][:message] }
  end

  def unauthorized
    flash[:errors] = "unauthorized"
    redirect_to root_path
  end
end
