class HostMailer < ActionMailer::Base
  default from: "no-reply@travel-home.herokuapp.com"

  def reservation_request(reservation)
    @reservation = reservation
    mail(to: reservation.host.email_address,
    subject: 'Someone Wants to Stay At Your Place!')   end

  def cancellation_email(reservation)
    @reservation = reservation
    mail(to: reservation.host.email_address,
    subject: 'Reservation Cancellation')
  end
end
