class RemoveImageColumnsNotNeeded < ActiveRecord::Migration
  def change
    remove_column :photos, :image_content_type
    remove_column :photos, :image_file_size
  end
end
