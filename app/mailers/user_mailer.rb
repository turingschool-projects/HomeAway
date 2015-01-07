class UserMailer < ActionMailer::Base
  default from: "no-reply@travel-home.herokuapp.com"

  def welcome_email(user)
    mail(to: user.email_address,
    subject: 'Welcome to TravelHome!') do |format|
      format.text { render text: "Dear #{user.name},\n\nWelcome to TravelHome! Please visit http://travel-home.herokuapp.com#{edit_user_path(user)} and add your address to complete the sign-up process.\n\nOnce you're done, feel free to browse our locations at http://travel-home.herokuapp.com#{properties_path} to find your next dream vacation destination. Happy Travels!\n\nBest Regards,\n\n--TravelHome" }
    end
  end

  def reservation_request(reservation)
    recipients = [reservation.host.email_address]
    reservation.host.each
    mail(to: reservation.host.email_address,
    subject: 'Someone Wants to Stay At Your Place!') do |format|
      format.text { render text: "Dear #{reservation.host.name},\n\nYour property, #{reservation.property.title} has been requested for a reservation by #{reservation.user.name} for the dates of #{reservation.pretty_start_date} to #{reservation.pretty_end_date}. To review and manage your reservation requests, visit http://travel-home.herokuapp.com#{my_guests_path}.\n\nBest Regards,\n\n--TravelHome"}
    end
  end

  def cancellation_email(reservation)
    mail(to: reservation.host.email_address,
    subject: 'Reservation Cancellation') do |format|
      format.text { render text: "Dear #{reservation.host.name},\n\nThe previously requested reservation by #{reservation.user.name} for #{reservation.property.title} has been cancelled. We hope all is well.\n\nBest Regards,\n\n--TravelHome" }
    end
  end
end
