class Favorites < ActiveRecord::Migration
  def change
		create_table :favorites do |t|
	    t.integer :user_id
	    t.integer :property_id
	    t.timestamps
	  end
  end
end
