class ReservationsController < ApplicationController
  def new
    redirect_to login_path unless current_user
  end

  def create
    if current_user
      @cart.save_reservation_for current_user
      redirect_to reservation_path(current_user.reservations.last)
    else
      flash[:error] = "You must be logged in to checkout"
      redirect_to :back
    end
  end

  def index
    if current_user
      @reservations = current_user.reservations
      render :index
    else
      flash[:error] = "You must be logged in to view your reservations."
      redirect_to root_path
    end
  end

  def show
    @reservation = current_user && current_user.reservations.where(id: params[:id]).take
    if @reservation
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
      flash[:errors] = @reservation.errors.map {|attr, msg| "#{attr}: #{msg}" }.join("\n")
    end
  end

  private

  def reservation_update_params
    params.require(:reservation).permit(:address)
  end
end
