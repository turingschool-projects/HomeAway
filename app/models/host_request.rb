class HostRequest < ActiveRecord::Base
	include InvalidatesCache
	
  belongs_to :user
  validates :user, :message, presence: true
end
