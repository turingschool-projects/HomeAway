class Favorite < ActiveRecord::Base
  include InvalidatesCache

	belongs_to :user
	belongs_to :property
end