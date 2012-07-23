class UserAvail < ActiveRecord::Base
  belongs_to :user
  belongs_to :area
  attr_accessible :day, :avail_from, :avail_to, :avail_option, :area_id

  validates :user_id,    presence: true
  validates :day,        presence: true
end
