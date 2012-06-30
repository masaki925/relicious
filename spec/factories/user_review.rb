# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_review do
    user
    meetup
    association :reviewed_user, factory: :user
    recommend  true
    about_user "about_user"
    about_experience  "about_experience"
    eval_personal 1
    eval_language 2
    eval_gourmet  3
  end
end