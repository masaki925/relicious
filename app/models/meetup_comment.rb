class MeetupComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :meetup
  attr_accessible :body

  validates :user_id,   :presence => true
  validates :meetup_id, :presence => true
  validates :body,      :presence => true
end
