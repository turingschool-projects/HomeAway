class Order < ActiveRecord::Base
  has_many :items, through: :order_items
  belongs_to :user
  has_many :order_items
end
