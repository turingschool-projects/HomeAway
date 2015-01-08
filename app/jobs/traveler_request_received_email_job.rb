class TravelerRequestReceivedEmailJob
  include SuckerPunch::Job

  def perform(email_data)
    HostMailer.cancellation_email(email_data).deliver
  end
end
