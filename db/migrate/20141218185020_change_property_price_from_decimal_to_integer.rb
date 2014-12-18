class ChangePropertyPriceFromDecimalToInteger < ActiveRecord::Migration
  def up
    change_column :properties, :price, :integer
  end

  def down
    change_column :properties, :price, :decimal
  end
end
