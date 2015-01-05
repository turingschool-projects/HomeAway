class HostRequest < ActiveRecord::Base
  belongs_to :user
  validates :user, :message, presence: true
end
