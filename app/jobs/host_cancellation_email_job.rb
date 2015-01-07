class HostCancellationEmailJob
  include SuckerPunch::Job

  def perform(reservation)
    HostMailer.cancellation_email(reservation).deliver
  end
end
