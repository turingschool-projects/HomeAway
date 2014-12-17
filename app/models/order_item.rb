class ReservationItem < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :item

  after_create :update_reservation

  scope :retired, -> { joins(:item).where(items: { retired: true }) }

  private

  def update_reservation
    reservation.save
  end
end
