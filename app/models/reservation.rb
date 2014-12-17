class Reservation < ActiveRecord::Base
  include AASM
  has_many :reservation_properties
  has_many :properties, through: :reservation_properties
  belongs_to :user

  validates :user, presence: true

  before_save :calculate_total

  scope :past_reservations, -> { where(status: [:reserved, :paid, :completed, :cancelled]) }

  aasm column: :status do
    # each state has a predicate method we can use to check status, like .in_cart?
    state :in_cart, initial: true
    state :reserved
    state :paid
    state :cancelled
    state :completed

    # events give us bang methods, like place! for changing reservation status
    event :place do
      transitions from: :in_cart, to: :reserved, guard: :no_retired_properties?
    end

    event :pay do
      transitions from: :reserved, to: :paid
    end

    event :cancel do
      transitions from: [:reserved, :paid], to: :cancelled
    end

    event :complete do
      transitions from: :paid, to: :completed
    end
  end

  def editable?
    in_cart? || reserved? || paid?
  end

  def calculate_total
    self.total = properties.sum(:price)
  end

  def update_quantities
    current_quantities = quantities
    properties.each do |property|
      property.quantity = current_quantities[property.id].quantity
    end
  end

  def quantities
    properties.group_by(&:id).inject({}) do |memo, (k, properties)|
      memo[k] = properties.first
      memo[k].quantity = properties.count
      memo
    end
  end

  def decrease(property)
    reservation_properties.find_by(property_id: property.id).destroy
    reload
    calculate_total
    update_quantities
  end

  def remove_property(property)
    reservation_properties.where(property: property).joins(:property).destroy_all
    properties.reload
    save!
    update_quantities
  end

  def increase(property)
    properties << property
    properties.reload
    save!
    update_quantities
  end

  def subtotal(property)
    quantity = quantities[property.id].quantity
    quantity * property.price
  end

  def no_retired_properties?
    return true if reservation_properties.retired.empty?
    reservation_properties.retired.delete_all
    false
  end
end
