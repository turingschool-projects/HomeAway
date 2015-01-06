class PartnersController < ApplicationController

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
    partner = User.find_by(id: params[:id])
    if partner && current_user
      current_user.partners.delete partner
      redirect_to user_path(current_user)
    elsif current_user
      flash[:errors] = "This user don't exist anyhow"
      redirect_to user_path(current_user)
    else
      flash[:errors] = "wat are you doing here brah"
      redirect_to root_path
    end
  end
end
