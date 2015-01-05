class CreateUserConnections < ActiveRecord::Migration
  def change
    create_table :user_connections do |t|
      t.integer :host_id
      t.integer :partner_id

      t.timestamps
    end
  end
end
