class User < ActiveRecord::Base
  has_secure_password

  has_and_belongs_to_many(:partners, join_table: :user_connections, class_name: "User",
                          foreign_key: :host_id, association_foreign_key: :partner_id)
  has_and_belongs_to_many(:owners, join_table: :user_connections, class_name: "User",
                          association_foreign_key: :host_id, foreign_key: :partner_id)

  belongs_to :address
  accepts_nested_attributes_for :address
  has_many :reservations
  has_many :properties
  has_many :favorites
  has_many :host_requests
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email_address, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :name, presence: true
  validates :display_name, length: {minimum: 2, maximum: 32}, allow_blank: true

  scope :hosts, -> { where(host: true) }

  def slug
    host_slug.present? ? "#{id}-#{host_slug}" : id
  end

  def accepted_payments
    payments = []
    payments << "Credit Card" if accepts_cc?
    payments << "Check" if accepts_check?
    payments << "Cash" if accepts_cash? || (!accepts_cc && !accepts_check)
    payments
  end

  def retire_listings
    properties.each {|property| property.update_attribute :retired, true }
  end

  def only_host?
    host && !admin
  end

  def destroy
    transaction do
      raise "Hey, this user has properties, you shouldn't delete them!" unless properties.empty?
      super
    end
  end

  def email_data
    {
      "user_name" => "#{name}",
      "email_address" => "#{email_address}",
      "id" => "#{id}"
    }
  end

  def partner_reservations
    if owners.empty?
      0
    else
      owners.reduce(0) { |sum, owner| sum + owner.reservations.pending.count }
    end
  end
end
