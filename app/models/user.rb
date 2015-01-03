class User < ActiveRecord::Base
  has_secure_password
  belongs_to :address
  accepts_nested_attributes_for :address
  has_many :reservations
  has_many :properties
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email_address, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :name, presence: true
  validates :display_name, length: {minimum: 2, maximum: 32}, allow_blank: true
  validates :host_slug, uniqueness: true

  scope :hosts, -> { where(host: true) }

  before_save :generate_host_slug

  def generate_host_slug
    if host && host_slug.nil?
      self.host_slug = display_name.parameterize
    elsif host && host_slug
      self.host_slug = host_slug.parameterize
    end
  end

  def accepted_payments
    payments = []
    payments << "Credit Card" if accepts_cc?
    payments << "Check" if accepts_check?
    payments << "Cash" if accepts_cash? || (!accepts_cc && !accepts_check)
    payments
  end
end
