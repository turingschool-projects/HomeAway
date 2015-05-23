require 'rails_helper'

RSpec.describe Photo, :type => :model do
  it "must belong to a property" do
    photo = build(:photo, image_file_name: "app/assets/images/ext_apt_1.jpg", property: nil)
    expect(photo).to_not be_valid

    photo = create(:photo,image_file_name: "app/assets/images/ext_apt_1.jpg")
    expect(photo).to be_valid
  end

  it "has an image" do
    photo = create(:photo,image_file_name: "app/assets/images/ext_apt_1.jpg")
    expect(photo.image_file_name).to eq("app/assets/images/ext_apt_1.jpg")
  end
end
