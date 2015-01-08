class TravelerDenialEmailJob
  include SuckerPunch::Job

  def perform(email_data)
    TravelerMailer.denial_email(email_data).deliver
  end
end
