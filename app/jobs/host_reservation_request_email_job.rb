class HostReservationRequestEmailJob
  include SuckerPunch::Job

  def perform(email_data)
    HostMailer.reservation_request(email_data).deliver
  end
end
