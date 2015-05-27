class AddIndexToFavorites < ActiveRecord::Migration
  def change
  	add_index :favorites, [:user_id, :property_id], unique: true
  end
end
