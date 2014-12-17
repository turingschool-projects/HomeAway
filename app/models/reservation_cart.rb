class ReservationCart
  include Enumerable

  attr_reader :reservation

  def initialize(reservation)
    @reservation = reservation
    update_quantities
  end

  def add_property(property)
    reservation.reservation_properties.create!(property: property)
    reservation.properties.reload
    update_quantities
  end

  def remove_property(property)
    reservation.reservation_properties.where(property: property).joins(:property).destroy_all
    reservation.properties.reload
    reservation.save!
    update_quantities
  end

  def decrease(property)
    property = reservation.reservation_properties.where(property: property).joins(:property).take
    property.destroy
    reservation.properties.reload
    reservation.save!
    update_quantities
  end

  def increase(property)
    reservation.properties << property
    reservation.properties.reload
    reservation.save!
    update_quantities
  end

  def subtotal(property)
    count_of(property) * property.price
  end

  def count_of(property)
    quantities[property.id].quantity
  end

  def total_properties
    reservation.properties.size
  end

  def total_cost
    reservation.total
  end

  def to_h
    quantities.inject({}) do |memo, (_, property)|
      memo[property.id] = property.quantity
      memo
    end
  end

  def each(&block)
    quantities.values.each(&block)
  end

  private

  def update_quantities
    current_quantities = quantities
    reservation.properties.each do |property|
      property.quantity = current_quantities[property.id].quantity
    end
  end

  def quantities
    reservation.properties.group_by(&:id).inject({}) do |memo, (k, properties)|
      memo[k] = properties.first
      memo[k].quantity = properties.count
      memo
    end
  end
end
