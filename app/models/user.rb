class User < ActiveRecord::Base
  has_secure_password
  has_many :orders
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email_address, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :name, presence: true
  validates :display_name, length: {minimum: 2, maximum: 32}, allow_blank: true
end
