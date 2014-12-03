class UsersController < ApplicationController
	before_action :set_user, only: [:show, :update]
	def index
		@users = User.all
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			redirect_to @user
		else
			render :new
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
		@user = User.find(params[:id])
	end

	def show

	end

  private
  def user_params
    params.require(:user).permit(:email_address, :name, :display_name, :password, :password_confirmation)
  end

	def set_user
		@user = User.find(params[:id])
	end
end
