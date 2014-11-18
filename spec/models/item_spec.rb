require 'rails_helper'

describe Item do
  it { should have_attribute(:title) }
  it { should have_attribute(:description) }
  it { should have_attribute(:price) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  it { should validate_uniqueness_of(:title) }

  it { should validate_numericality_of(:price).
    is_greater_than(0) }

  xit { should have_many(:item_categories) }
  xit { should have_many(:categories).through :item_categories }
end
# The photo is optional. If not present, a stand-in photo is used.
