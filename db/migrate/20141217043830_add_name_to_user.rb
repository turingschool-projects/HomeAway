class AddNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string

    reversible do |dir|
      change_table :users do |t|
        dir.up do
          t.remove :first_name, :last_name
        end

        dir.down do
          t.string :first_name
          t.string :last_name
        end
      end
    end
  end
end
