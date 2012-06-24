class UserAvail < ActiveRecord::Base
  belongs_to :user
  belongs_to :area
  attr_accessible :avail_from, :avail_to, :avail_option, :area_id

  validates :user_id,    presence: true
  validates :area_id,    presence: true
  validates :avail_from, presence: true
  validates :avail_to,   presence: true
end
