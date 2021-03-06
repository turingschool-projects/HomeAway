class ReservationsController < ApplicationController
  def my_guests
    if current_user_is_host
      @reservations = Reservation.guests_for current_user.id
    else
      flash[:error] = "You must be a host to see your guests"
      redirect_to root_path
    end
  end

  def partner_guests
    if current_user_is_partner
      @reservations = current_user.owner_ids.flat_map {|id| Reservation.guests_for(id)}
    end
  end

  def create
    if current_user
      if @cart.save_reservation_for current_user
        redirect_to reservation_path(current_user.reservations.last)
      else
        flash[:error] = "Could not checkout reservation. Try again."
        redirect_to :back
      end
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
    @reservation = Reservation.find(params[:id])
    if current_user_is_admin || [@reservation.user_id, @reservation.host.id].include?(current_user.id)
      render :show
    else
      flash[:error] = "You may only view your own reservations"
      redirect_to root_path
    end
  end

  def edit
  end

  def update
    @reservation = Reservation.find(params[:id])
    if @reservation.host == current_user
      increment_state(@reservation)
      redirect_to "/my_guests"
    elsif @reservation.host.partners.include? current_user
      increment_state(@reservation)
      redirect_to "/partner_guests"
    elsif @reservation.user == current_user
      @reservation.cancel! if params[:cancel]
      redirect_to :back
    else
      redirect_to "/my_guests"
      flash[:errors] = @reservation.errors.full_messages.join("<br>")
    end
  end

  def pay
    Payments.process_payment(@cart, current_user, params[:stripeToken])
    create
    flash[:notice] = "Payment of $#{@cart.total} accepted"

  rescue Stripe::CardError => e
    flash[:error] = e.message
  end

  private

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

  def current_user_is_partner
    !current_user.owners.empty?
  end
end
