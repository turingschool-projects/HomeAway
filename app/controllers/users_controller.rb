class UsersController < ApplicationController
	before_action :require_current_user, except: [:new, :create]

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			session[:user_id] = @user.id
			redirect_to root_path
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
    params.require(:user).permit(:email_address, :name, :display_name, :password, :password_confirmation)
  end

	def require_current_user
		@user = current_user
	end

	def unauthorized
		flash[:errors] = "You can only view your own information"
		redirect_to root_path
	end
end
