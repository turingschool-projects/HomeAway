class FavoritesController < ApplicationController
	def index
		@properties = Property.where(id: Favorite.where(user_id: current_user.id).pluck(:property_id)).search(params[:search], params[:moneySlide], params[:category]).paginate(:page => params[:page], :per_page => 6)
	end	

	def create
		property_id = params[:wishlist][:property_id].to_i
		user_id = current_user.id

		Favorite.create(user_id: user_id, property_id: property_id)
		redirect_to :back
	end

	def destroy
		Favorite.destroy(params[:id])
		redirect_to :back
	end
end