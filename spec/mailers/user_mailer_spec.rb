require "rails_helper"

RSpec.describe UserMailer, :type => :mailer do
  it "can send a welcome email" do
    user = create(:user, email_address: "viki@example.com")
    UserMailer.welcome_email(user).deliver
    result = ActionMailer::Base.deliveries.last

    expect(result).not_to be_nil
    expect(result.to).to include "viki@example.com"
    expect(result.from).to include "no-reply@travel-home.herokuapp.com"
    expect(result.subject).to eq "Welcome to TravelHome!"
  end
end
