class Photo < ActiveRecord::Base
  has_attached_file :image,
    styles: {
    hero: '1280x768',
    thumb: '100x100>',
    medium: '235x135',
  },
  default_url: 'ext_balloon_1.jpg'

  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]

  belongs_to :property
end
