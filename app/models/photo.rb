class Photo < ActiveRecord::Base
  belongs_to :property

  validates :image_file_name, presence: true, allow_blank: false
  validates :property, presence: true

  before_save :clear_primary,
              if: Proc.new { |photo| (photo.new_record? && photo.primary? ) || (photo.primary_changed? && photo.primary?) }

  def clear_primary
    self.property.photos.update_all({primary: false})
  end

end
