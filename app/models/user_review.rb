class UserReview < ActiveRecord::Base
  attr_accessible :about_experience, :about_user, :eval_gourmet, :eval_language, :eval_personal, :reviewed_user_id, :recommend, :meetup_id

  belongs_to :user
  belongs_to :meetup
  has_one :reviewed_user, class_name: "User"

  validates :user_id, :presence => true
  validates :meetup_id, :presence => true
  validates :reviewed_user_id, :presence => true
end
