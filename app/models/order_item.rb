class ReservationProperty < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :property

  after_create :update_reservation

  scope :retired, -> { joins(:property).where(properties: { retired: true }) }

  private

  def update_reservation
    reservation.save
  end
end
