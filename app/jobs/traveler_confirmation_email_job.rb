class TravelerConfirmationEmailJob
  include SuckerPunch::Job

  def perform(email_data)
    TravelerMailer.confirmation_email(email_data).deliver
  end
end
