class Cart
  attr_reader :data

  def initialize(input_data)
    @data = cart_contents(input_data) || Hash.new
  end

  def add_item(item)
    data[item.id] ||= item
    data[item.id].quantity ||= 0
    data[item.id].quantity += 1
  end

  def count_of(item)
    data[item.id].quantity
  end

  def count_total
    data.values.sum
  end

  def cart_contents(cart_data)
    contents = {}
    return contents unless cart_data
    Item.where(id: cart_data.keys).inject(contents) do |memo, item|
      item.quantity = cart_data[item.id.to_s]
      memo[item.id] = item
    end
    contents
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
    end
    hash
  end
end
