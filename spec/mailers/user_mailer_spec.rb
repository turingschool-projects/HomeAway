require "rails_helper"

RSpec.describe UserMailer, :type => :mailer do
  let(:user) { create(:user, name: "Test Name") }

  it "can send a welcome email" do
    UserMailer.welcome_email(user).deliver
    result = ActionMailer::Base.deliveries.last

    expect(result).not_to be_nil
    expect(result.to).to include user.email_address
    expect(result.from).to include "no-reply@travel-home.herokuapp.com"
    expect(result.subject).to eq "Welcome to TravelHome!"
  end
end
