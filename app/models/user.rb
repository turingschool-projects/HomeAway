class User < ActiveRecord::Base
  has_secure_password
  belongs_to :address
  has_many :reservations
  has_many :properties
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email_address, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :name, presence: true
  validates :display_name, length: {minimum: 2, maximum: 32}, allow_blank: true

  scope :hosts, -> { where(host: true) }

  before_save :generate_url

  def generate_url
    if host && url.nil?
      self.url = display_name.parameterize
    end
  end
end
