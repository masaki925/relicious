class UserMeetupPermission < ActiveRecord::Base
  attr_accessible :user_id, :meetup_id, :status

  belongs_to :user
  belongs_to :meetup

  validates_presence_of :user_id, :meetup_id, :status
  validates_uniqueness_of :meetup_id, :scope => [:user_id]
end
