class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :item

  after_save :update_order

  def update_order
    order.save
  end
end
