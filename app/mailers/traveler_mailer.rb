class TravelerMailer < ActionMailer::Base
  default from: "no-reply@travel-home.herokuapp.com"

  def request_received(reservation)
    mail(to: reservation.user.email_address,
    subject: 'Reservation Request Received') do |format|
      format.text { render text: "Dear #{reservation.user.name},\n\nWe have received your request for a reservation at #{reservation.property.title} for the dates of #{reservation.pretty_start_date} to #{reservation.pretty_end_date}. The owner of the property has been notified of your request and will get back to you soon.\n\nReservation total: $#{reservation.total}\n\nNightly rate: $#{reservation.property.price}\n\nOther reservation details: http://travel-home.herokuapp.com#{reservation_path(reservation)}\n\nBest Regards,\n\n--TravelHome"}
    end
  end

  def confirmation_email(reservation)
    mail(to: reservation.user.email_address,
    subject: 'Reservation Approved!') do |format|
      format.text { render text: "Dear #{reservation.user.name},\n\nYour host, #{reservation.host.name}, has approved your reservation at #{reservation.property.title} for the dates of #{reservation.pretty_start_date} to #{reservation.pretty_end_date}. Enjoy your stay!\n\nBest Regards,\n\n--TravelHome" }
    end
  end

  def denial_email(reservation)
    mail(to: reservation.user.email_address,
    subject: 'Reservation Declined') do |format|
      format.text { render text: "Dear #{reservation.user.name},\n\nWe regret to inform you that the reservation you requested for #{reservation.property.title} for the dates of #{reservation.pretty_start_date} to #{reservation.pretty_end_date} has been denied. You will not be charged for this reservation. Sorry about that!\n\nBest Regards,\n\n--TravelHome" }
    end
  end
end
