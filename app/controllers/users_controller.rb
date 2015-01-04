class UsersController < ApplicationController
  before_action :require_current_user, except: [:create]

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      UserMailer.welcome_email(@user).deliver
      redirect_to :back
    else
      flash[:errors] = "Invalid Sign-up. #{@user.errors.full_messages}"
      redirect_to :back
    end
  end

  def update
    @user.update(user_params)
    if @user.save
      redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  def edit
    return unauthorized unless current_user
    @user = User.find(params[:id])
    unless @user == current_user
      unauthorized
    end
  end

  def show
    @user = User.find(params[:id])
    unless current_user && current_user.admin?
      unless @user == current_user
        unauthorized
      end
    end
  end

  private
  def user_params
    params.require(:user).permit(:email_address, :name, :display_name, :password, :password_confirmation, :description, :host_slug, :accepts_cc, :accepts_cash, :accepts_check, address_attributes: [:id, :line_1, :line_2, :city, :state, :zip, :country])
  end

  def require_current_user
    @user = current_user
  end

  def unauthorized
    flash[:errors] = "You can only view your own information"
    redirect_to root_path
  end
end
