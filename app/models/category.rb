class Category < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  has_many :property_categories
  has_many :properties, through: :property_categories
end
