class UserMailer < ActionMailer::Base
  default from: "no-reply@travel-home.herokuapp.com"

  def welcome_email(user)
    @user = user
    mail(to: user.email_address,
    subject: 'Welcome to TravelHome!')
  end
end
