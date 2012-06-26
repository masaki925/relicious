class Meetup < ActiveRecord::Base
  attr_accessible :begin_at, :end_at, :public, :title, :area_id

  belongs_to :user
  belongs_to :area

  has_many   :meetup_comments, dependent: :destroy
  has_many   :user_meetup_permissions
  has_many   :users, through: :user_meetup_permissions

  validates :user_id, :presence => true
  validates :area_id, :presence => true
  validates :begin_at, :presence => true
  validates :end_at, :presence => true
end
