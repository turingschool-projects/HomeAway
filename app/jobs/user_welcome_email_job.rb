class UserWelcomeEmailJob
  include SuckerPunch::Job

  def perform(email_data)
    UserMailer.welcome_email(email_data).deliver
  end
end
