class RemoveImageFieldsFromProperty < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :properties do |t|
        dir.up do
          t.remove :image_file_name, :image_content_type, :image_file_size, :image_updated_at
        end

        dir.down do
          t.string   "image_file_name"
          t.string   "image_content_type"
          t.integer  "image_file_size"
          t.datetime "image_updated_at"
        end
      end
    end
  end
end
