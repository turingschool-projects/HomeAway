class ReservationsController < ApplicationController
  def index
    @reservations = current_user.reservations.past_reservations
  end

  def show
    @reservation = current_user.reservations.where(id: params[:id]).take
    if @reservation
      @reservation.update_quantities
      render :show
    else
      flash[:error] = "You may only view your own reservations"
      redirect_to root_path
    end
  end

  def edit
    @reservation = @cart.reservation
  end

  def update
    @reservation = @cart.reservation
    if @reservation.update(reservation_update_params)
      @reservation.place! if @reservation.in_cart?
      redirect_to @reservation
    else
      redirect_to edit_reservation_path
      flash[:errors] = "You need an address if you want delivery"
      flash[:errors] = @reservation.errors.map {|attr, msg| "#{attr}: #{msg}" }.join("\n")
    end
  end

  private

  def reservation_update_params
    params.require(:reservation).permit(:address, :delivery)
  end
end
