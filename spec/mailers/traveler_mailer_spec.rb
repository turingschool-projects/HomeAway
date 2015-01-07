require "rails_helper"

RSpec.describe TravelerMailer, :type => :mailer do
  let(:traveler) { create(:user, name: "Test Name") }
  let(:host) { create(:host, name: "Test Name") }
  let(:property) { create(:property, user: host) }
  let(:reservation) { create(:reservation, user: traveler, property: property) }

  it "can send confirmation of reservation request receipt" do
    TravelerMailer.request_received(reservation).deliver
    result = ActionMailer::Base.deliveries.last

    expect(result).not_to be_nil
    expect(result.to).to include traveler.email_address
    expect(result.from).to include "no-reply@travel-home.herokuapp.com"
    expect(result.subject).to eq "Reservation Request Received"
    expect(result.body).to include traveler.name
    expect(result.body).to include property.title
    expect(result.body).to include reservation.total
    expect(result.body).to include reservation.pretty_start_date
    expect(result.body).to include reservation.pretty_end_date
  end

  it "can send confirmation of reservation approval" do
    TravelerMailer.confirmation_email(reservation).deliver
    result = ActionMailer::Base.deliveries.last

    expect(result).not_to be_nil
    expect(result.to).to include traveler.email_address
    expect(result.from).to include "no-reply@travel-home.herokuapp.com"
    expect(result.subject).to eq "Reservation Approved!"
    expect(result.body).to include traveler.name
    expect(result.body).to include property.title
    expect(result.body).to include reservation.host.name
    expect(result.body).to include reservation.pretty_start_date
    expect(result.body).to include reservation.pretty_end_date
  end

  it "can send denial of reservation request email" do
    TravelerMailer.denial_email(reservation).deliver
    result = ActionMailer::Base.deliveries.last

    expect(result).not_to be_nil
    expect(result.to).to include traveler.email_address
    expect(result.from).to include "no-reply@travel-home.herokuapp.com"
    expect(result.subject).to eq "Reservation Declined"
    expect(result.body).to include traveler.name
    expect(result.body).to include property.title
    expect(result.body).to include reservation.pretty_start_date
    expect(result.body).to include reservation.pretty_end_date
  end
end
