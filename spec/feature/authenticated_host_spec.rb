require 'rails_helper'

context "authenticated host", type: :feature do
  let(:file_path) do
    Rails.root.join('spec', 'fixtures', 'images')
  end

  let!(:traveler) { create(:user) }
  let!(:host) { create(:host) }
  let!(:property) { create(:property, user: host) }
  let!(:retired_property) { create(:property, user: host, retired: true) }
  let!(:reservation) { create(:reservation, property: property, user: traveler) }

  it "can see my_guests page containing all incoming reservations" do
    login(host)
    visit my_guests_path
    expect(page).to have_content("pending")
    expect(page).to have_content(reservation.property.title)
    expect(page).to have_content(reservation.user.name)
  end

  it "can confirm reservations on my_guests" do
    login(host)
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
    login(host)
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
    login(host)
    expect(host.properties.count).to eq 2
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
    expect(host.properties.count).to eq 3
  end

  it "can add photos to a property" do
    login(host)
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
    login(host)
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
    login(host)
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
    login(host)
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

  it "can manage own property photos but not other hosts' property photos" do
    other_host_property = create(:property)
    login(host)
    visit property_photos_path(property)
    expect(page).to have_content(property.title)

    visit property_photos_path(other_host_property)
    expect(page).to have_content("You may only manage your own property photos")
  end
end
