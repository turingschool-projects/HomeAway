class ChangeStatusInReservations < ActiveRecord::Migration
  def change
    change_column_default :reservations, :status, "pending"
  end
end
