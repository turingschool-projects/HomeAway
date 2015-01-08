class TravelerRequestReceivedEmailJob
  include SuckerPunch::Job

  def perform(email_data)
    TravelerMailer.request_received(email_data).deliver
  end
end
