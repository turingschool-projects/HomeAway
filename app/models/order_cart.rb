class ReservationCart
  include Enumerable

  attr_reader :reservation

  def initialize(reservation)
    @reservation = reservation
    update_quantities
  end

  def add_item(item)
    reservation.reservation_items.create!(item: item)
    reservation.items.reload
    update_quantities
  end

  def remove_item(item)
    reservation.reservation_items.where(item: item).joins(:item).destroy_all
    reservation.items.reload
    reservation.save!
    update_quantities
  end

  def decrease(item)
    item = reservation.reservation_items.where(item: item).joins(:item).take
    item.destroy
    reservation.items.reload
    reservation.save!
    update_quantities
  end

  def increase(item)
    reservation.items << item
    reservation.items.reload
    reservation.save!
    update_quantities
  end

  def subtotal(item)
    count_of(item) * item.price
  end

  def count_of(item)
    quantities[item.id].quantity
  end

  def total_items
    reservation.items.size
  end

  def total_cost
    reservation.total
  end

  def to_h
    quantities.inject({}) do |memo, (_, item)|
      memo[item.id] = item.quantity
      memo
    end
  end

  def each(&block)
    quantities.values.each(&block)
  end

  private

  def update_quantities
    current_quantities = quantities
    reservation.items.each do |item|
      item.quantity = current_quantities[item.id].quantity
    end
  end

  def quantities
    reservation.items.group_by(&:id).inject({}) do |memo, (k, items)|
      memo[k] = items.first
      memo[k].quantity = items.count
      memo
    end
  end
end
