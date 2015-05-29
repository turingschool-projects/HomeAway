class Admin::ReservationsController < Admin::BaseAdminController
  before_action :set_reservation, except: [:index, :pending, :completed, :reserved, :cancelled]

  def index
    @reservations = Reservation.all.paginate(:page => params[:page], :per_page => 15)
  end

  def update
    unless increment_state(@reservation)
      flash[:errors] = @reservation.errors.full_messages.join("<br>")
    end
    redirect_to admin_reservations_path
  end

  def destroy
    property = Property.find(params[:remove])
    @reservation.remove_property(property)
    redirect_to admin_reservation_path(@reservation)
  end

  def show
    @reservation.update_quantities
  end

  def pending
    @reservations = Reservation.pending
    render :index
  end

  def reserved
    @reservations = Reservation.reserved.paginate(:page => params[:page], :per_page => 6)
    render :index
  end

  def cancelled
    @reservations = Reservation.cancelled.paginate(:page => params[:page], :per_page => 6)
    render :index
  end

  def completed
    @reservations = Reservation.completed.paginate(:page => params[:page], :per_page => 6)
    render :index
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def increment_state(reservation)
    case
    when params[:confirm]
      reservation.confirm!
    when params[:deny]
      reservation.deny!
    when params[:cancel]
      reservation.cancel!
    when params[:complete]
      reservation.complete!
    end
  end
end
