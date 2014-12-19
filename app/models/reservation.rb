class Reservation < ActiveRecord::Base
  include AASM
  belongs_to :property
  belongs_to :user

  validates :user, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  scope :upcoming, -> { where(status: [:pending, :reserved]) }

  aasm column: :status do
    # each state has a predicate method we can use to check status, like .in_cart?
    state :pending, initial: true
    state :reserved
    state :cancelled
    state :completed

    # events give us bang methods, like place! for changing reservation status
    event :confirm do
      transitions from: :pending, to: :reserved
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
    property.price * duration / 100.0
  end

  def duration
    end_date - start_date
  end
end
