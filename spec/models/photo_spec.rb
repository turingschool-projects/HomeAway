require 'rails_helper'

RSpec.describe Photo, :type => :model do
  it "must belong to a property" do
    photo = Photo.create(image: File.open("app/assets/images/ext_apt_1.jpg"))
    expect(photo).to_not be_valid

    property =
    photo = Photo.create(image: File.open("app/assets/images/ext_apt_1.jpg"), property_id: 1)
    expect(photo).to be_valid
  end

  it "has an image" do
    photo = Photo.create(image: File.open("app/assets/images/ext_apt_1.jpg"), property_id: 1)
    expect(photo.image).to_not be_nil
  end
end
