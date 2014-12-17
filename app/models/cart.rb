class Cart
  include Enumerable

  def initialize(input_data)
    @data = cart_contents(input_data) || Hash.new
  end

  def add_property(property)
    data[property.id] ||= property
    data[property.id].quantity ||= 0
    data[property.id].quantity += 1
  end

  def remove_property(property)
    data.delete(property.id)
  end

  def decrease(property)
    data[property.id].quantity -= 1
    data.delete(property.id) if data[property.id].quantity < 1
  end

  def increase(property)
    data[property.id].quantity += 1
  end

  def subtotal(property)
    count_of(property) * property.price
  end

  def count_of(property)
    data[property.id].quantity
  end

  def total_properties
    to_h.values.sum
  end


  def total_cost
    data.inject(0) do |sum, (_, property)|
      sum += (property.price * property.quantity)
    end
  end

  def to_h
    hash = {}
    data.inject(hash) do |hash, (id, property)|
      hash[id] = property.quantity
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
    Property.where(id: cart_data.keys).inject(contents) do |memo, property|
      property.quantity = cart_data[property.id.to_s]
      memo[property.id] = property
      memo
    end
    contents
  end
end
