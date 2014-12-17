class CartReservationConverter
  def self.convert(session_cart, user)
    new.convert(session_cart, user)
  end

  def convert(session_cart, user)
    reservation = Reservation.create!(user: user)
    properties = Property.where(id: session_cart.keys)
    properties.each do |property|
      create_reservation_properties(session_cart, property, reservation)
    end
    reservation
  end

  def create_reservation_properties(session_cart, property, reservation)
    quantity = session_cart[property.id]
    quantity.times do
      ReservationProperty.create!(property: property, reservation: reservation)
    end
  end
end
