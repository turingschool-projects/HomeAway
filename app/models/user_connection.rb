class UserConnection < ActiveRecord::Base
  belongs_to :host, class_name: :User
  belongs_to :partner, class_name: :User
end
