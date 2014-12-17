class AddHostToUsers < ActiveRecord::Migration
  def change
    add_column :users, :host, :boolean
    add_reference :users, :address, index: true

    rename_column :users, :name, :first_name

    add_column :users, :last_name, :string
  end
end
