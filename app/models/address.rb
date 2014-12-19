class Address < ActiveRecord::Base
  validates :line_1, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true

  #geocoded_by :full_street_address
  #after_validation :geocode, if: :full_street_address_changed?

  def full_street_address
    "#{line_1} #{city} #{state} #{zip}"
  end

  def full_street_address_changed?
    :line_1_changed? || :city_changed? || :state_changed? || :zip_changed?
  end
end
