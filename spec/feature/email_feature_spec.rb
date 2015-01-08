require 'rails_helper'

describe "email feature", type: :feature do
  let(:start_date) { 1.year.from_now }
  let(:end_date) { 1.year.from_now.advance(days: 5)}

  let!(:traveler) { create(:user, name: "Test Name") }
  let!(:host) { create(:host, name: "Test Host Name") }
  let!(:property1) { create(:property, user: host) }
  let!(:property2) { create(:property, user: host) }
  let!(:reservation) { create(:reservation, user: traveler, property: property1) }

  context "host" do
    it "receives an email when a guest cancels a reservation" do
      login(traveler)
      visit reservation_path(reservation)
      find_button("Cancel").click
      reservation.reload
      expect(reservation.status).to eq "cancelled"
      result = ActionMailer::Base.deliveries.last
      expect(result).not_to be_nil
      expect(result.to).to include host.email_address
      expect(result.from).to include "no-reply@travel-home.herokuapp.com"
      expect(result.subject).to eq "Reservation Cancellation"
      expect(result.body).to include host.name
      expect(result.body).to include traveler.name
      expect(result.body).to include property1.title
    end

    it "receives an email when a guest requests a reservation" do
      login(traveler)
      visit properties_path
      click_link_or_button property1.title
      fill_in "property[reservation]", with: "#{start_date} - #{end_date}"
      click_link_or_button "Request reservation"
      expect(page).to have_content property1.title
      expect(property1.reload.user).to eq host

      fake_mailer = double("mailer", :deliver => nil)
      expect(TravelerMailer).to receive(:request_received).and_return(fake_mailer)

      click_link_or_button "Pay"
      reservation = Reservation.last

      expect(reservation.status).to eq "pending"
      result = ActionMailer::Base.deliveries.last
      expect(result).not_to be_nil
      expect(result.to).to include host.email_address
      expect(result.from).to include "no-reply@travel-home.herokuapp.com"
      expect(result.subject).to eq "Someone Wants to Stay At Your Place!"
      expect(result.body).to include host.name
      expect(result.body).to include traveler.name
      expect(result.body).to include property1.title
      expect(result.body).to include reservation.pretty_start_date
      expect(result.body).to include reservation.pretty_end_date
    end
  end

  context "traveler" do
    it "receives an email when it requests a reservation" do
      login(traveler)
      visit properties_path
      click_link_or_button property1.title
      fill_in "property[reservation]", with: "#{start_date} - #{end_date}"
      click_link_or_button "Request reservation"
      expect(page).to have_content property1.title
      expect(property1.reload.user).to eq host


      click_link_or_button "Pay"
      reservation = Reservation.last

      expect(reservation.status).to eq "pending"
      result = ActionMailer::Base.deliveries.last

      expect(result).not_to be_nil
      expect(result.to).to include traveler.email_address
      expect(result.from).to include "no-reply@travel-home.herokuapp.com"
      expect(result.subject).to eq "Reservation Request Received"
      expect(result.body).to include traveler.name
      expect(result.body).to include property1.title
      expect(result.body).to include reservation.pretty_start_date
      expect(result.body).to include reservation.pretty_end_date
      expect(result.body).to include reservation.total
    end

    it "receives an email when a host confirms reservation" do
      login(host)
      visit "/my_guests"
      find_button("confirm").click
      expect(reservation.reload.status).to eq "reserved"

      result = ActionMailer::Base.deliveries.last

      expect(result).not_to be_nil
      expect(result.to).to include traveler.email_address
      expect(result.from).to include "no-reply@travel-home.herokuapp.com"
      expect(result.subject).to eq "Reservation Approved!"
      expect(result.body).to include traveler.name
      expect(result.body).to include property1.title
      expect(result.body).to include reservation.host.name
      expect(result.body).to include reservation.pretty_start_date
      expect(result.body).to include reservation.pretty_end_date
    end
  end
end
