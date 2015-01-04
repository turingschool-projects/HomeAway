class Property < ActiveRecord::Base
  attr_accessor :quantity
  validates :title, presence: true
  validates :description, presence: true, length: { maximum: 500 }
  validates :price, numericality: {greater_than: 0}
  validates :category_id, presence: true
  monetize :price_cents
  alias_method :daily_rate, :price
  # validates :address, presence: true

  belongs_to :user
  belongs_to :category
  belongs_to :address
  accepts_nested_attributes_for :address

  has_many :reservations

  has_many :photos
  has_many :other_photos, -> { where(primary: false) }, class: Photo

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

  def location
    address.city
  end

  def self.search(key)
    if key
      joins(:address).where("addresses.city ILIKE ?", "%#{key}%")
    else
      active
    end
  end
end
