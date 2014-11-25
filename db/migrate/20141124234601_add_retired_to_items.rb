class AddRetiredToItems < ActiveRecord::Migration
  def change
    add_column :items, :retired, :boolean, default: false
  end
end
