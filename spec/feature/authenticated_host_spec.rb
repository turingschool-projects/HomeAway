require 'rails_helper'

context "authenticated host", type: :feature do
  let(:file_path) do
    Rails.root.join('spec', 'fixtures', 'images')
  end
  before(:each) do
    address = create(:address, line_1: "213 Some St",
    city: "Denver",
    state: "CO",
    zip: "80203")
    traveler = create(:user, name: "traveler jim",
    email_address: "traveler@example.com",
    password: "password",
    password_confirmation: "password")
    host = create(:user, name: "Boy George",
    email_address: "cultureclubforever@eighties.com",
    password: "password",
    password_confirmation: "password",
    host_slug: "boy_george_4evah",
    address: address,
    host: true)
    category = create(:category,name: "awesome place")
    property1 = create(:property, title: "My Cool Home",
    description: "cool description",
    occupancy: 4, price: 666,
    bathroom_private: false,
    category: category,
    address: address,
    user: host)
    property2 = create(:property, title: "A Retired Home",
    description: "retired description",
    occupancy: 4, price: 666,
    bathroom_private: false, retired: true,
    category: category,
    address: address,
    user: host)
    reservation1 = create(:reservation,start_date: Date.current.advance(days: 1),
    end_date: Date.current.advance(days: 4), property: property1,
    user: traveler)

    visit root_path
    fill_in "email_address", with: host.email_address
    fill_in "password", with: host.password
    find_button("Login").click
  end

  it "can see my_guests page containing all incoming reservations" do
    visit my_guests_path
    expect(page).to have_content("pending")
    expect(page).to have_content("My Cool Home")
    expect(page).to have_content("traveler jim")
  end

  it "can confirm reservations on my_guests" do
    reservation = Reservation.last
    visit my_guests_path
    within(".reservation_#{reservation.id}") do
      expect(page).to have_content("pending")
      find_button("confirm").click
    end
    within(".reservation_#{reservation.id}") do
      expect(page).to have_content("reserved")
    end
  end

  it "can deny reservations on my_guests" do
    reservation = Reservation.last
    visit my_guests_path

    within(".reservation_#{reservation.id}") do
      expect(page).to have_content("pending")
      find_button("deny").click
    end
    within(".reservation_#{reservation.id}") do
      expect(page).to have_content("denied")
    end
  end

  it "can add a property" do
    expect(User.last.properties.count).to eq 2
    find_link("My Profile").click
    find_link("Add a new property").click

    fill_in "Title", with: "sweet pad"
    fill_in "Description", with: "realleh realleh sweet pad"
    fill_in "Price", with: 500
    fill_in "Occupancy", with: 2

    within(".address") do
      fill_in "property_address_attributes_line_1", with: "123 Some St"
      fill_in "property_address_attributes_city", with: "Denver"
      fill_in "property_address_attributes_state", with: "CO"
      fill_in "property_address_attributes_zip", with: 80203
    end

    find_button("Create Property").click
    expect(current_path).to eq property_photos_path(Property.last)
    expect(page).to have_content("sweet pad")
    expect(User.last.properties.count).to eq 3
  end

  it "can add photos to a property" do
    property = Property.last
    find_link("My Profile").click
    within ".property_#{property.id}" do
      find_link("Manage photos").click
    end
    find_link("Add Photo").click
    page.attach_file("photo_image", file_path.join("ext_apt_1.jpg"))
    find_button("Create Photo").click
    expect(property.photos.count).to eq 1
    expect(property.photos.first.image_file_name).to eq("ext_apt_1.jpg")
  end

  it "can set and change primary photo" do
    property = Property.last
    find_link("My Profile").click
    within ".property_#{property.id}" do
      find_link("Manage photos").click
    end
    find_link("Add Photo").click
    page.attach_file("photo_image", file_path.join("ext_apt_1.jpg"))
    check("photo_primary")
    find_button("Create Photo").click

    find_link("Add Photo").click
    page.attach_file("photo_image", file_path.join("ext_balloon_1.jpg"))
    find_button("Create Photo").click

    within(".primary") do
      expect(page).to have_css("img[src$='ext_apt_1.jpg']")
    end

    find_link("Make Primary").click

    within(".primary") do
      expect(page).to have_css("img[src$='ext_balloon_1.jpg']")
    end
  end

  it "can delete an image from the photos page" do
    property = Property.last
    find_link("My Profile").click
    within ".property_#{property.id}" do
      find_link("Manage photos").click
    end
    find_link("Add Photo").click
    page.attach_file("photo_image", file_path.join("ext_apt_1.jpg"))
    check("photo_primary")
    find_button("Create Photo").click

    find_link("Add Photo").click
    page.attach_file("photo_image", file_path.join("ext_balloon_1.jpg"))
    find_button("Create Photo").click

    find_link("Remove Photo").click
    expect(page).to_not have_css("img[src$='ext_balloon_1.jpg']")
  end

  it "sees an error message if the photo doesn't save" do
    property = Property.last
    find_link("My Profile").click
    within ".property_#{property.id}" do
      find_link("Manage photos").click
    end
    find_link("Add Photo").click
    check("photo_primary")
    find_button("Create Photo").click

    expect(current_path).to eq property_photos_path(property)
    expect(page).to have_content "prohibited this photo"

    page.attach_file("photo_image",  file_path.join("ext_apt_1.jpg"))
    check("photo_primary")
    find_button("Create Photo").click

    expect(current_path).to eq property_photos_path(property)
    visit edit_property_photo_path(property, Photo.last)
    page.attach_file("photo_image", file_path.join("blank.txt"))
    find_button("Update Photo").click
    expect(page).to have_content "prohibited this photo"
  end
end
