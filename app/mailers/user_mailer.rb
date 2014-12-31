class UserMailer < ActionMailer::Base
  default from: "no-reply@mighty-escarpment-8434.herokuapp.com"

  def confirmation_email(reservation)
    mail(to: reservation.user.email_address,
    subject: 'Reservation Approved!') do |format|
      format.text { render text: "Dear #{reservation.user.name},\nYour host, #{reservation.property.user.name}, has approved your reservation at #{reservation.property.title} for the dates of #{reservation.pretty_start_date} to #{reservation.pretty_end_date}. Enjoy your stay!\n\nBest Regards,\n\n--TravelHome" }
    end
  end
end
