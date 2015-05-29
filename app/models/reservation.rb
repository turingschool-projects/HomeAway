class Reservation < ActiveRecord::Base
  include AASM
  include InvalidatesCache

  belongs_to :property
  belongs_to :user

  validates :user, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :start_date_cannot_be_in_the_past,
           :end_date_is_greater_than_start_date,
           :dates_are_not_already_booked

  scope :upcoming, -> { where(status: [:pending, :reserved]) }
  scope :denied_or_cancelled, -> { where(status: [:denied, :cancelled]) }
  scope :guests_for, ->(user_id) { joins(:property).where(properties: { user_id: user_id }).includes(:user) }

  aasm column: :status do
    # each state has a predicate method we can use to check status, like .pending?
    state :pending, initial: true
    state :reserved
    state :denied
    state :cancelled
    state :completed

    # events give us bang methods, like confirm! for changing reservation status
    event :confirm do
      transitions from: :pending, to: :reserved
      after do
        TravelerConfirmationEmailJob.new.async.perform(email_data)
      end
    end

    event :cancel, guard: :not_past? do
      transitions from: :pending, to: :cancelled
      after do
        HostCancellationEmailJob.new.async.perform(email_data)
      end
    end

    event :deny do
      transitions from: :pending, to: :denied
      after do
        TravelerDenialEmailJob.new.async.perform(email_data)
      end
    end

    event :complete do
      transitions from: :reserved, to: :completed, guard: :past?
    end
  end

  self.per_page = 15

  def state_buttons
    buttons = []
    buttons << "confirm" if may_confirm?
    buttons << "deny" if may_deny?
    buttons << "complete" if may_complete?
    buttons
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

  def date_range
    start_date..end_date
  end

  def not_past?
    start_date.present? && start_date >= Date.current && end_date >= Date.current
  end

  def past?
    start_date.present? && end_date < Date.current
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
    booked_dates = Reservation.all.where(property_id: property_id).where.not(id: id).map(&:date_range)
    booked_dates.any? { |booked_date| date_range.overlaps?(booked_date) }
  end

  def pretty_start_date
    start_date.strftime("%B %d, %Y")
  end

  def pretty_end_date
    end_date.strftime("%B %d, %Y")
  end

  def host
    property.user
  end

  def email_data
    { "host_email_address" => "#{host.email_address}",
      "traveler_email_address" => "#{user.email_address}",
      "host_name" => "#{host.name}",
      "property_name" => "#{property.title}",
      "traveler_name" => "#{user.name}",
      "start_date" => "#{pretty_start_date}",
      "end_date" => "#{pretty_end_date}",
      "total" => "$#{total}",
      "price" => "$#{property.price}",
      "id" => "#{id}"
    }
  end
end
