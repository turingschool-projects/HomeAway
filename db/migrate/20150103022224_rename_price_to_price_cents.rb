class RenamePriceToPriceCents < ActiveRecord::Migration
  def change
    rename_column :properties, :price, :price_cents
  end
end
