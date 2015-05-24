class FavoritesController < ApplicationController
	def index
		@favorites = Property.find(Favorite.where(user_id: current_user.id).pluck(:property_id))
	end

	def create
		user_id = current_user.id
		Favorite.create(user_id: user_id, property_id: )
		redirect_to :back
		flash[:alert] = "This awesome property has been added to your wishlist."
	end
end