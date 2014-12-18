class AddDefaultToCountryInAddress < ActiveRecord::Migration
  def change
    change_column_default :addresses, :country, "USA"
  end
end
