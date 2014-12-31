class Address < ActiveRecord::Base
  validates :line_1, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true

  def escape_street
    line_1.gsub(" ", "+")
  end

  def escape_city
    city.gsub(" ", "+")
  end
end
