class UserMailer < ActionMailer::Base
  default from: "no-reply@travel-home.herokuapp.com"

  def welcome_email(user)
    mail(to: user.email_address,
    subject: 'Welcome to TravelHome!') do |format|
      format.text { render text: "Dear #{user.name},\n\nWelcome to TravelHome! Please visit http://travel-home.herokuapp.com#{edit_user_path(user)} and add your address to complete the sign-up process.\n\nOnce you're done, feel free to browse our locations at http://travel-home.herokuapp.com#{properties_path} to find your next dream vacation destination. Happy Travels!\n\nBest Regards,\n\n--TravelHome" }
    end
  end

  def reservation_request(reservation)
    mail(to: reservation.host.email_address,
    subject: 'Someone Wants to Stay At Your Place!') do |format|
      format.text { render text: "Dear #{reservation.host.name},\n\nYour property, #{reservation.property.title} has been requested for a reservation by #{reservation.user.name} for the dates of #{reservation.pretty_start_date} to #{reservation.pretty_end_date}. To review and manage your reservation requests, visit http://travel-home.herokuapp.com#{my_guests_path}.\n\nBest Regards,\n\n--TravelHome"}
    end
  end

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

  def cancellation_email(reservation)
    mail(to: reservation.host.email_address,
    subject: 'Reservation Cancellation') do |format|
      format.text { render text: "Dear #{reservation.host.name},\n\nThe previously requested reservation by #{reservation.user.name} for #{reservation.property.title} has been cancelled. We hope all is well.\n\nBest Regards,\n\n--TravelHome" }
    end
  end

  def denial_email(reservation)
    mail(to: reservation.user.email_address,
    subject: 'Reservation Declined') do |format|
      format.text { render text: "Dear #{reservation.user.name},\n\nWe regret to inform you that the reservation you requested from #{reservation.host.name} for #{reservation.property.title} for the dates of #{reservation.pretty_start_date} to #{reservation.pretty_end_date} has been denied. Sorry about that!\n\nBest Regards,\n\n--TravelHome" }
    end
  end
end
