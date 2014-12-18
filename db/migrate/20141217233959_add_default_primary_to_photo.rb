class AddDefaultPrimaryToPhoto < ActiveRecord::Migration
  def change
    change_column_default :photos, :primary, false
  end

end
