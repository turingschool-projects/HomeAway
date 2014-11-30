class CartOrderConverter
  def self.convert(session_cart, user)
    new.convert(session_cart, user)
  end

  def convert(session_cart, user)
    order = Order.create!(user: user)
    items = Item.where(id: session_cart.keys)
    items.each do |item|
      create_order_items(session_cart, item, order)
    end
    order
  end

  def create_order_items(session_cart, item, order)
    quantity = session_cart[item.id]
    quantity.times do
      OrderItem.create!(item: item, order: order)
    end
  end
end
