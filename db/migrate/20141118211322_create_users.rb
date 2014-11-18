class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email_address
      t.string :name
      t.string :display_name
      t.string :password_digest
      t.boolean :admin

      t.timestamps
    end
  end
end
