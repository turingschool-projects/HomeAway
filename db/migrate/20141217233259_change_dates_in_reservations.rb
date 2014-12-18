class ChangeDatesInReservations < ActiveRecord::Migration
  def up
    change_column :reservations, :start_date, :date
    change_column :reservations, :end_date, :date
  end

  def down
    change_column :reservations, :start_date, :datetime
    change_column :reservations, :end_date, :datetime
  end
end
