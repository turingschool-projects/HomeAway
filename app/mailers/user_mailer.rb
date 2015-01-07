class UserMailer < ActionMailer::Base
  default from: "no-reply@travel-home.herokuapp.com"

  def welcome_email(user)
    mail(to: user.email_address,
    subject: 'Welcome to TravelHome!') do |format|
      format.text { render text: "Dear #{user.name},\n\nWelcome to TravelHome! Please visit http://travel-home.herokuapp.com#{edit_user_path(user)} and add your address to complete the sign-up process.\n\nOnce you're done, feel free to browse our locations at http://travel-home.herokuapp.com#{properties_path} to find your next dream vacation destination. Happy Travels!\n\nBest Regards,\n\n--TravelHome" }
    end
  end
end
