class Item < ActiveRecord::Base
  validates :title, presence: true, uniqueness: true
  validates :description, presence: true
  validates :price, numericality: {greater_than: 0}

  has_many :item_categories
  has_many :categories, through: :item_categories
  has_many :order_items
  has_many :orders, through: :order_items

  has_attached_file :image,
  styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
    },
  :default_url => 'Gourmet_hamburger_with_bacon.jpg'

  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]

  def update_categories(category_ids)
    self.categories = Category.where(id: category_ids)
    save!
  end
end
