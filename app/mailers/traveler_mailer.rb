class TravelerMailer < ActionMailer::Base
  default from: "no-reply@travel-home.herokuapp.com"

  def request_received(reservation)
    @reservation = reservation
    mail(to: reservation.user.email_address,
    subject: 'Reservation Request Received')
  end

  def confirmation_email(reservation)
    @reservation = reservation
    mail(to: reservation.user.email_address,
    subject: 'Reservation Approved!')
  end

  def denial_email(reservation)
    mail(to: reservation.user.email_address,
    subject: 'Reservation Declined') do |format|
      format.text { render text: "Dear #{reservation.user.name},\n\nWe regret to inform you that the reservation you requested for #{reservation.property.title} for the dates of #{reservation.pretty_start_date} to #{reservation.pretty_end_date} has been denied. You will not be charged for this reservation. Sorry about that!\n\nBest Regards,\n\n--TravelHome" }
    end
  end
end
