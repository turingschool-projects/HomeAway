class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :description, :text
    add_column :users, :accepts_cc, :boolean
    add_column :users, :accepts_cash, :boolean
    add_column :users, :accepts_check, :boolean
    add_column :users, :host_slug, :string
  end
end
