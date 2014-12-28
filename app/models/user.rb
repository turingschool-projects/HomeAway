class User < ActiveRecord::Base
  has_secure_password
  belongs_to :address
  accepts_nested_attributes_for :address
  has_many :reservations
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email_address, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :name, presence: true
  validates :display_name, length: {minimum: 2, maximum: 32}, allow_blank: true

  def accepted_payments
    payments = []
    payments << "Credit Card" if accepts_cc?
    payments << "Cash" if accepts_cash?
    payments << "Check" if accepts_check?
    payments
  end
end
