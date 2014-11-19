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

  it { should have_many(:item_categories) }
  it { should have_many(:categories) }

  it { should have_many(:orders)}
end
# The photo is optional. If not present, a stand-in photo is used.
