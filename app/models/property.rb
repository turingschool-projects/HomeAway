class Property < ActiveRecord::Base
  attr_accessor :quantity
  validates :title, presence: true, uniqueness: true
  validates :description, presence: true, length: { maximum: 500 }
  validates :price, numericality: {greater_than: 0}
  validates :category_id, presence: true

  belongs_to :user
  belongs_to :category
  belongs_to :address
  has_many :reservations

  has_attached_file :image,
  styles: {
    thumb: '100x100>',
    medium: '235x135!>',
    },
  default_url: 'gourmet_hamburger_with_bacon.jpg'

  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]

  scope :active, -> { where(retired: false) }
  scope :retired, -> { where(retired: true) }

  def bathroom
    bathroom_private == true ? "Private" : "Shared"
  end
end
