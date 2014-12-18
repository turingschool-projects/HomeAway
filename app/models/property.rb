class Property < ActiveRecord::Base
  attr_accessor :quantity
  validates :title, presence: true, uniqueness: true
  validates :description, presence: true, length: { maximum: 500 }
  validates :price, numericality: {greater_than: 0}
  validates :category_id, presence: true

  belongs_to :user
  belongs_to :category
  belongs_to :address
  has_many :reservations

  scope :active, -> { where(retired: false) }
  scope :retired, -> { where(retired: true) }

  has_many :photos

  def bathroom
    bathroom_private == true ? "Private" : "Shared"
  end

  def primary
    photos.where(primary: true).take
  end

  def other_photos
    photos.where(primary: false)
  end

  def location
    address.city
  end

  def daily_rate
    price / 100.0
  end
end
