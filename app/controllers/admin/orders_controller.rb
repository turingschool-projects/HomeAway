class Admin::ReservationsController < Admin::BaseAdminController
  before_action :set_reservation, except: [:index, :completed, :reserved, :cancelled, :paid]

  def index
    @reservations = Reservation.past_reservations
  end

  def update
    if params[:decrease]
      item = Item.find(params[:decrease])
      @reservation.decrease(item)
    elsif params[:increase]
      item = Item.find(params[:increase])
      @reservation.increase(item)
    end
    redirect_to admin_reservation_path(@reservation)
  end

  def destroy
    item = Item.find(params[:remove])
    @reservation.remove_item(item)
    redirect_to admin_reservation_path(@reservation)
  end

  def show
    @reservation.update_quantities
  end

  def reserved
    @reservations = Reservation.reserved
    render :index
  end

  def cancelled
    @reservations = Reservation.cancelled
    render :index
  end

  def paid
    @reservations = Reservation.paid
    render :index
  end

  def completed
    @reservations = Reservation.completed
    render :index
  end

  def pay
    @reservation.pay!
    redirect_to admin_reservations_path
  end

  def complete
    @reservation.complete!
    redirect_to admin_reservations_path
  end

  def cancel
    @reservation.cancel!
    redirect_to admin_reservations_path
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end
end
