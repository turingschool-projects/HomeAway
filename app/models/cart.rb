class Cart
  def initialize(input_data)
    @data = input_data || {}
  end

  def to_h
    {}
  end

  private
  attr_reader :data
end
