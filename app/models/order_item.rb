class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :item

  after_create :update_order

  def update_order
    order.save
  end
end
