class ChangeImageNameToTextType < ActiveRecord::Migration
  def change
    remove_column :photos, :image_file_name
    add_column :photos, :image_file_name, :text
  end
end
