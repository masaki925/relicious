class Meetup < ActiveRecord::Base
  belongs_to :user
  belongs_to :area
  has_many   :meetup_comments, :dependent => :destroy
  attr_accessible :begin_at, :end_at, :public, :title, :area_id

  validates :user_id, :presence => true
  validates :area_id, :presence => true
  validates :begin_at, :presence => true
  validates :end_at, :presence => true
end
