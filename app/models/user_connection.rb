class UserConnection < ActiveRecord::Base
	include InvalidatesCache
	
  belongs_to :host, class_name: :User
  belongs_to :partner, class_name: :User
end
