class OrderCart
  include Enumerable

  attr_reader :order

  def initialize(order)
    @order = order
    update_quantities
  end

  def add_item(item)
    order.order_items.create!(item: item)
    order.items.reload
    update_quantities
  end

  def remove_item(item)
    order.order_items.where(item: item).joins(:item).destroy_all
    order.items.reload
    order.save!
    update_quantities
  end

  def decrease(item)
    item = order.order_items.where(item: item).joins(:item).take
    item.destroy
    order.items.reload
    order.save!
    update_quantities
  end

  def increase(item)
    order.items << item
    order.items.reload
    order.save!
    update_quantities
  end

  def subtotal(item)
    count_of(item) * item.price
  end

  def count_of(item)
    quantities[item.id].quantity
  end

  def total_items
    order.items.size
  end

  def total_cost
    order.total
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
    order.items.each do |item|
      item.quantity = current_quantities[item.id].quantity
    end
  end

  def quantities
    order.items.group_by(&:id).inject({}) do |memo, (k, items)|
      memo[k] = items.first
      memo[k].quantity = items.count
      memo
    end
  end
end
