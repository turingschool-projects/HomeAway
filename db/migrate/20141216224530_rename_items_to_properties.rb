class RenameItemsToProperties < ActiveRecord::Migration
  def change
    rename_table "items", "properties"
  end
end
