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

  def save_reservation_for(user)
    raise "no user" unless user
    Reservation.create( status: "pending",
                        user: user,
                        property: property,
                        start_date: Date.parse(start_date),
                        end_date: Date.parse(end_date))
  end
end
