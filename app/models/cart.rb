class Cart
  include Enumerable

  def initialize(input_data)
    @data = cart_contents(input_data) || Hash.new
  end

  def add_item(item)
    data[item.id] ||= item
    data[item.id].quantity ||= 0
    data[item.id].quantity += 1
  end

  def remove_item(item)
    data.delete(item.id)
  end

  def decrease(item)
    data[item.id].quantity -= 1
    data.delete(item.id) if data[item.id].quantity < 1
  end

  def increase(item)
    data[item.id].quantity += 1
  end

  def subtotal(item)
    count_of(item) * item.price
  end

  def count_of(item)
    data[item.id].quantity
  end

  def total_items
    to_h.values.sum
  end


  def total_cost
    data.inject(0) do |sum, (_, item)|
      sum += (item.price * item.quantity)
    end
  end

  def to_h
    hash = {}
    data.inject(hash) do |hash, (id, item)|
      hash[id] = item.quantity
      hash
    end
  end

  def each(&block)
    data.values.each(&block)
  end

  private
  attr_reader :data

  def cart_contents(cart_data)
    contents = {}
    return contents unless cart_data
    Item.where(id: cart_data.keys).inject(contents) do |memo, item|
      item.quantity = cart_data[item.id.to_s]
      memo[item.id] = item
      memo
    end
    contents
  end
end
