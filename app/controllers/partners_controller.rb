class PartnersController < ApplicationController
  def new
  end

  def create
    partner = User.find_by(email_address: params[:user][:email_address])
    if partner && current_user
      current_user.partners << partner
      redirect_to user_path(current_user)
    elsif current_user
      flash[:errors] = "No user with email '#{params[:user][:email_address]}' could not be found"
      redirect_to user_path(current_user)
    else
      flash[:errors] = "wat are you doing here brah"
      redirect_to root_path
    end
  end

  def destroy
  end
end
