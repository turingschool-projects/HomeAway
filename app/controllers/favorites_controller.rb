class FavoritesController < ApplicationController
	def index
		binding.pry
		@properties = Property.where(id: Favorite.where(user_id: current_user.id).pluck(:property_id)).search(params[:search], params[:moneySlide], params[:category]).paginate(:page => params[:page], :per_page => 6)
	end	

	def create
		property_id = params[:wishlist][:property_id].to_i
		user_id = current_user.id

		Favorite.create(user_id: user_id, property_id: property_id)
		redirect_to :back
	end

	def destroy
		Favorite.find_by(user_id: current_user.id, property_id: params[:id]).destroy
		redirect_to :back
	end
end