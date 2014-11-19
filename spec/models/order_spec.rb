require 'rails_helper'

RSpec.describe Order, :type => :model do
  it { should have_attribute(:status) }
  it { should have_attribute(:address) }
  it { should have_many(:order_items) }
  it { should have_many(:items) }
  it { should belong_to(:user) }


  it 'should default status to false' do
    order = Order.create
    order.status = 'ordered'
  end

end