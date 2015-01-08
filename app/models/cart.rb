class Cart
  attr_reader :property
  def initialize(input_data)
    @data = input_data || {}
    clean
  end

  def add_property(property_params)
    @data["property_id"] = property_params[:property_id]
    @data["start_date"], @data["end_date"] = property_params[:reservation].split(" - ")
    clean
  end

  def to_h
    @data
  end

  def clear
    @data = {}
  end

  def empty?
    to_h.empty?
  end

  def clean
    clear unless Property.exists?(id: to_h["property_id"])
    set_property
  end

  def start_date
    to_h["start_date"]
  end

  def end_date
    to_h["end_date"]
  end

  def set_property
    @property = Property.find_by(id: to_h["property_id"])
  end

  def total
   @property.price * duration
  end

  def total_cents
    (@property.price * duration).to_i
  end

  def duration
    Date.parse(@data["end_date"]) - Date.parse(@data["start_date"])
  end

  def save_reservation_for(user)
    raise "no user" unless user
    reservation = Reservation.create( status: "pending",
                                      user: user,
                                      property: property,
                                      start_date: Date.parse(start_date),
                                      end_date: Date.parse(end_date))
    reservation.email_data
    HostReservationRequestEmailJob.new.async.perform(reservation.email_data)
  end

  def valid_dates?(dates, property)
    if dates.present? && property.present?
      start_date, end_date = dates.split(" - ").map{ |date| Date.parse(date) }
      start_date >= Date.current && end_date > start_date && !dates_booked(start_date, end_date, property)
    end
  end

  def dates_booked(start_date, end_date, property)
    date_range = start_date..end_date
    booked_dates = Reservation.all.where(property_id: property).map(&:date_range)
    booked_dates.any? { |booked_date| date_range.overlaps?(booked_date) }
  end

  def pretty_start_date
    Date.parse(start_date).strftime("%B %d, %Y")
  end

  def pretty_end_date
    Date.parse(end_date).strftime("%B %d, %Y")
  end
end
