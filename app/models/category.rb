class Category < ActiveRecord::Base
	include InvalidatesCache
	
  validates :name, presence: true, uniqueness: true
  has_many :properties
end
