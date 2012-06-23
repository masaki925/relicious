class Meetup < ActiveRecord::Base
  belongs_to :user
  has_many   :meetup_comments
  attr_accessible :begin_at, :end_at, :public, :title

  validates :user_id, :presence => true
  validates :begin_at, :presence => true
  validates :end_at, :presence => true
end
