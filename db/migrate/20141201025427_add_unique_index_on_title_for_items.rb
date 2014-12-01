class AddUniqueIndexOnTitleForItems < ActiveRecord::Migration
  def change
    add_index :items, :title, unique: true
    add_index :users, :email_address, unique: true
  end
end
