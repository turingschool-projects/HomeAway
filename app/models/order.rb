class Order < ActiveRecord::Base
  include AASM
  has_many :items, through: :order_items
  belongs_to :user
  has_many :order_items
  validates :user_id, presence: true
  validates :address, presence: true, if: :delivery?
  before_save :calculate_total

  aasm column: :status do
    # each state has a predicate method we can use to check status, like .in_cart?
    state :in_cart, initial: true
    state :ordered
    state :paid
    state :cancelled
    state :completed

    # events give us bang methods, like submit! for changing order status
    event :place do
      transitions from: :in_cart, to: :ordered
    end

    event :pay do
      transitions from: :ordered, to: :paid
    end

    event :cancel do
      transitions from: [:ordered, :paid], to: :cancelled
    end

    event :complete do
      transitions from: :paid, to: :completed
    end
  end

  def pickup?
    !delivery
  end

  def calculate_total
    self.total = items.sum(:price)
  end
end
