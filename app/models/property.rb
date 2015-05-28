class Property < ActiveRecord::Base
  include InvalidatesCache

  attr_accessor :quantity
  validates :title, presence: true
  validates :description, presence: true, length: { maximum: 500 }
  validates :price, numericality: {greater_than: 0}
  validates :category_id, presence: true
  monetize :price_cents
  alias_method :daily_rate, :price
  validates :address, presence: true

  belongs_to :user
  belongs_to :category
  belongs_to :address
  accepts_nested_attributes_for :address

  has_many :reservations
  has_many :favorites
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

  def booked_dates
    reservations.flat_map { |reservation| (reservation.start_date..reservation.end_date).map{ |date| date.strftime("%d-%m-%Y")} }
  end

  def hero_image
    primary.image_file_name
  end

  self.per_page = 6

  def self.search(city, money, categories)
    (city || money || categories) ? category_search(city, money, categories) : active
  end

  def self.price_range(money)
    price_low, price_high = money.split(",")
    (price_low.to_i * 100)..(price_high.to_i * 100)
  end

  def self.category_search(city, money, categories)
    search = search_without_categories(city, money)
    categories ? search.joins(:category).where(category: categories) : search
  end

  def self.search_without_categories(city, money)
    joins(:address).where("addresses.city ILIKE ?", "%#{city}%")
                   .where(price_cents: price_range(money))
  end

end
