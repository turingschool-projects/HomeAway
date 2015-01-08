class HostMailer < ActionMailer::Base
  default from: "no-reply@travel-home.herokuapp.com"

  def reservation_request(email_data)
    email_address = email_data["host_email_address"]
    @host_name = email_data["host_name"]
    @property_name = email_data["property_name"]
    @traveler_name = email_data["traveler_name"]
    @start_date = email_data["start_date"]
    @end_date = email_data["end_date"]


    mail(to: email_address,
    subject: 'Someone Wants to Stay At Your Place!')
  end

  def cancellation_email(email_data)
    email_address = email_data["host_email_address"]

    @host_name = email_data["host_name"]
    @traveler_name = email_data["traveler_name"]
    @property_name = email_data["property_name"]

    mail(to: email_address,
    subject: 'Reservation Cancellation')
  end
end
