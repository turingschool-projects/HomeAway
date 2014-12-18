class Reservation < ActiveRecord::Base
  include AASM
  belongs_to :property
  belongs_to :user

  validates :user, presence: true

  # We still need to do this, probably, but right now it doesn't work
  # before_save :calculate_total

  scope :past_reservations, -> { where(status: [:reserved, :completed, :cancelled]) }

  aasm column: :status do
    # each state has a predicate method we can use to check status, like .in_cart?
    state :pending, initial: true
    state :reserved
    state :cancelled
    state :completed

    # events give us bang methods, like place! for changing reservation status
    event :confirm do
      transitions from: :pending, to: :reserved, guard: :no_retired_properties?
    end

    event :cancel do
      transitions from: [:pending, :reserved], to: :cancelled
    end

    event :complete do
      transitions from: :reserved, to: :completed
    end
  end

  def editable?
    pending? || reserved?
  end

  def total
    property.price * duration
  end

  def duration
    end_date - start_date
  end

  def no_retired_properties?
    return true if reservation_properties.retired.empty?
    reservation_properties.retired.delete_all
    false
  end
end
