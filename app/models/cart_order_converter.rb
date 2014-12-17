class CartReservationConverter
  def self.convert(session_cart, user)
    new.convert(session_cart, user)
  end

  def convert(session_cart, user)
    reservation = Reservation.create!(user: user)
    items = Item.where(id: session_cart.keys)
    items.each do |item|
      create_reservation_items(session_cart, item, reservation)
    end
    reservation
  end

  def create_reservation_items(session_cart, item, reservation)
    quantity = session_cart[item.id]
    quantity.times do
      ReservationItem.create!(item: item, reservation: reservation)
    end
  end
end
