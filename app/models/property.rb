class Property < ActiveRecord::Base
  attr_accessor :quantity
  validates :title, presence: true
  validates :description, presence: true, length: { maximum: 500 }
  validates :price, numericality: {greater_than: 0}
  validates :category_id, presence: true
#  validates :address_id, presence: true

  belongs_to :user
  belongs_to :category
  belongs_to :address
  accepts_nested_attributes_for :address

  has_many :reservations

  has_many :photos
  accepts_nested_attributes_for :photos, reject_if: lambda {|attributes| attributes['image'].blank?}

  scope :active, -> { where(retired: false) }
  scope :retired, -> { where(retired: true) }
  scope :for_user, ->(user_id) { where(user_id: user_id) }


  def bathroom
    bathroom_private == true ? "Private" : "Shared"
  end

  def primary
    photos.where(primary: true).take || photos.first
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
