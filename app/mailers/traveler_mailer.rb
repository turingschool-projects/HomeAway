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
    @reservation = reservation
    mail(to: reservation.user.email_address,
    subject: 'Reservation Declined')
  end
end
