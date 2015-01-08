require 'rails_helper'

describe "email feature", type: :feature do
  let(:start_date) { 1.year.from_now }
  let(:end_date) { 1.year.from_now.advance(days: 5)}

  let!(:traveler) { create(:user, name: "Test Name") }
  let!(:host) { create(:host, name: "Test Host Name") }
  let!(:property1) { create(:property, user: host) }
  let!(:property2) { create(:property, user: host) }
  let!(:reservation) { create(:reservation, user: traveler, property: property1) }

  before(:each) { ActionMailer::Base.deliveries.clear }

  context "host" do
    it "receives an email when a guest cancels a reservation" do
      login(traveler)
      visit reservation_path(reservation)
      expect(HostMailer).to receive(:cancellation_email).and_return(double"mailer", :deliver => nil)
      find_button("Cancel").click
      expect(reservation.reload.status).to eq "cancelled"
    end

    it "receives an email when a guest requests a reservation" do
      login(traveler)
      visit properties_path
      click_link_or_button property2.title
      fill_in "property[reservation]", with: "#{start_date} - #{end_date}"
      click_link_or_button "Request reservation"
      expect(page).to have_content property2.title

      expect(HostMailer).to receive(:reservation_request).and_return(double("mailer", :deliver => nil))

      click_link_or_button "Pay"
      reservation = Reservation.last
      expect(reservation.status).to eq "pending"
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

      expect(TravelerMailer).to receive(:request_received).and_return(double("mailer", :deliver => nil))
      click_link_or_button "Pay"
      reservation = Reservation.last

      expect(reservation.status).to eq "pending"
    end

    it "receives an email when a host confirms reservation" do
      login(host)
      visit "/my_guests"
      expect(TravelerMailer).to receive(:confirmation_email).and_return(double("mailer", :deliver => nil))
      find_button("confirm").click
      expect(reservation.reload.status).to eq "reserved"
    end

    it "receives an email when a host denies reservation" do
      login(host)
      visit "/my_guests"
      expect(TravelerMailer).to receive(:denial_email).and_return(double("mailer", :deliver => nil))
      find_button("deny").click
      expect(reservation.reload.status).to eq "denied"
    end
  end
end
