class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :item

  after_create :update_order

  scope :retired, -> { joins(:item).where(items: { retired: true }) }

  private

  def update_order
    order.save
  end
end
