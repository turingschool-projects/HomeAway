class HostMailer < ActionMailer::Base
  default from: "no-reply@travel-home.herokuapp.com"

  def reservation_request(reservation)
    @reservation = reservation
    mail(to: reservation.host.email_address,
    subject: 'Someone Wants to Stay At Your Place!')   end

  def cancellation_email(reservation)
    mail(to: reservation.host.email_address,
    subject: 'Reservation Cancellation') do |format|
      format.text { render text: "Dear #{reservation.host.name},\n\nThe previously requested reservation by #{reservation.user.name} for #{reservation.property.title} has been cancelled. We hope all is well.\n\nBest Regards,\n\n--TravelHome" }
    end
  end
end
