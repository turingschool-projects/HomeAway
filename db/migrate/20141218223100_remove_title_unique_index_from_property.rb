class RemoveTitleUniqueIndexFromProperty < ActiveRecord::Migration
  def change
    remove_index :properties, column: :title
  end
end
