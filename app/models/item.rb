class Property < ActiveRecord::Base
  attr_accessor :quantity
  validates :title, presence: true, uniqueness: true
  validates :description, presence: true, length: { maximum: 120 }
  validates :price, numericality: {greater_than: 0}
  validates :categories, presence: true

  has_many :property_categories
  has_many :categories, through: :property_categories
  has_many :reservation_properties
  has_many :reservations, through: :reservation_properties

  has_attached_file :image,
  styles: {
    thumb: '100x100>',
    medium: '235x135!>',
    },
  default_url: 'gourmet_hamburger_with_bacon.jpg'

  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]

  scope :active, -> { where(retired: false) }
  scope :retired, -> { where(retired: true) }
end
