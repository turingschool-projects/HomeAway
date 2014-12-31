class UserMailer < ActionMailer::Base
  default from: "no-reply@mighty-escarpment-8434.herokuapp.com"

  def confirmation_email(reservation)
    mail(to: reservation.user.email_address,
    subject: 'Reservation Approved!') do |format|
      format.text { render text: "Dear #{reservation.user.name},\nYour host, #{reservation.property.user.name}, has approved your reservation at #{reservation.property.title} for the dates of #{reservation.pretty_start_date} to #{reservation.pretty_end_date}. Enjoy your stay!\n\nBest Regards,\n\n--TravelHome" }
    end
  end

  def cancellation_email(reservation)
    mail(to: reservation.property.user.email_address,
    subject: 'Reservation Cancellation') do |format|
      format.text { render text: "Dear #{reservation.property.user.name},\nThe previously requested reservation by #{reservation.user.name} for #{reservation.property.title} has been cancelled. We hope all is well.\n\nBest Regards,\n\n--TravelHome"}
    end
  end
end
