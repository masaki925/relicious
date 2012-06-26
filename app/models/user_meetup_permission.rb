class UserMeetupPermission < ActiveRecord::Base
  belongs_to :user
  belongs_to :meetup

  validates_presence_of :user_id, :meetup_id
end
