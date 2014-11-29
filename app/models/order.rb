class Order < ActiveRecord::Base
  has_many :items, through: :order_items
  belongs_to :user
  has_many :order_items
  validates :user_id, presence: true
  validates :address, presence: true, if: :delivery?
  before_save :calculate_total

  def pickup?
    !delivery
  end

  def calculate_total
    self.total = items.sum(:price)
  end
end
