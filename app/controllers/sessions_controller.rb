class SessionsController < ApplicationController
  rescue_from ActionController::InvalidAuthenticityToken do
    redirect_to root_path
  end

  def new
    @session = session
  end

  def create
    session[:return_to] ||= request.referer
    user = User.find_by(email_address: params[:email_address])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Welcome, #{user.name}!"
      redirect_to :back
      #user.admin? ? redirect_to(admin_properties_path) : redirect_to(root_path)
    else
      flash[:errors] = "Invalid Login"
      redirect_to :back
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end

end
