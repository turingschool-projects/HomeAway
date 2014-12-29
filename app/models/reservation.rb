class Reservation < ActiveRecord::Base
  include AASM
  belongs_to :property
  belongs_to :user

  validates :user, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :start_date_cannot_be_in_the_past,
           :end_date_is_greater_than_start_date,
           :dates_are_not_already_booked

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

  def date_range
    start_date..end_date
  end

  def start_date_cannot_be_in_the_past
    if start_date.present? && start_date < Date.current
      errors.add(:start_date, "can't be in the past")
    end
  end

  def end_date_is_greater_than_start_date
    if start_date.present? && end_date.present? && end_date < start_date
      errors.add(:end_date, "cannot be before the start date")
    end
  end

  def dates_are_not_already_booked
    if start_date.present? && end_date.present? && dates_already_booked
      errors.add(:date_range, "these dates are already booked")
    end
  end

  def dates_already_booked
    booked_dates = Reservation.all.where(property_id: property_id).map(&:date_range)
    booked_dates.any? { |booked_date| date_range.overlaps?(booked_date) }
  end
end
