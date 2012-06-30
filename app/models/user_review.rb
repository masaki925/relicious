class UserReview < ActiveRecord::Base
  belongs_to :user
  belongs_to :meetup
  belongs_to :reviewed_user, class_name: "User"

  attr_accessible :about_experience, :about_user, :eval_gourmet, :eval_language, :eval_personal, :reviewed_user_id, :recommend
end
