require 'rails_helper'

RSpec.describe Category, :type => :model do
  it { should have_attribute(:name) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  it { should have_many(:item_categories) }
  it {should have_many(:items).through :item_categories }
end
