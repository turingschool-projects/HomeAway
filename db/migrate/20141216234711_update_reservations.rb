class UpdateReservations < ActiveRecord::Migration
  def change
    add_reference :reservations, :property
    add_column :reservations, :start_date, :datetime
    add_column :reservations, :end_date, :datetime

    reversible do |dir|
      change_table :reservations do |t|
        dir.up do
          t.remove :delivery, :address, :total
        end

        dir.down do
          t.boolean :delivery
          t.string :address
          t.decimal :total
        end
      end
    end
  end
end
